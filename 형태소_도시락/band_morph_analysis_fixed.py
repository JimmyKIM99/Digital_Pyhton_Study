# -*- coding: utf-8 -*-
"""
Band-wise Korean Morphological Analysis for Product Names
- Real analyzers: KoNLPy (Okt preferred; Mecab if available); graceful fallback to regex.
- Extract only Nouns/Adjectives.
- Extended stopwords (brand-like, units/quantities) + optional user stopword file.
- Co-occurrence graph & WordCloud (with Korean font auto-detection).
- Band-wise relative TF-IDF comparison (Band1 vs Band2).
- All CSVs saved with UTF-8-SIG. Images saved as PNG with Korean font set.
Usage (default autodetects your latest files):
    python band_morph_analysis.py --outdir ./out
Optional:
    --summary "/path/스윗스팟_분석_요약_통합_최저4000제외.csv"
    --data "/path/분석사용데이터_통합_최저4000제외.csv"
    --font "/path/to/Korean.ttf"
    --stopwords "/path/to/extra_stopwords.txt"
"""

import os, re, math, itertools, argparse, json
from collections import Counter
from typing import List, Tuple, Dict

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# -------------------------
# I/O helpers
# -------------------------
def pick_first_exist(paths):
    for p in paths:
        if p and os.path.exists(p):
            return p
    return None

def read_csv_u(path):
    return pd.read_csv(path, encoding="utf-8-sig")

def write_csv_u(df, path):
    df.to_csv(path, index=False, encoding="utf-8-sig")

def parse_band_range(s: str) -> Tuple[int, int]:
    m = re.search(r"\[(\d+)\s*~\s*(\d+)\)", str(s))
    if not m:
        return None, None
    return int(m.group(1)), int(m.group(2))

# -------------------------
# Font detection (for Korean)
# -------------------------
def pick_korean_font_path(cli_font: str = None) -> str:
    # Priority: user-provided -> common font locations
    candidates = []
    if cli_font and os.path.exists(cli_font):
        candidates.append(cli_font)
    candidates += [
        # Linux
        "/usr/share/fonts/truetype/nanum/NanumGothic.ttf",
        "/usr/share/fonts/truetype/noto/NotoSansCJK-Regular.ttc",
        "/usr/share/fonts/truetype/noto/NotoSansKR-Regular.otf",
        "/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc",
        # macOS
        "/System/Library/Fonts/AppleGothic.ttf",
        "/System/Library/Fonts/Supplemental/AppleGothic.ttf",
        "/Library/Fonts/AppleGothic.ttf",
        "/Library/Fonts/NanumGothic.ttf",
        "/Library/Fonts/NotoSansCJKkr-Regular.otf",
        # Windows
        "C:/Windows/Fonts/malgun.ttf",
        "C:/Windows/Fonts/malgunbd.ttf",
        "C:/Windows/Fonts/NanumGothic.ttf",
        "C:/Windows/Fonts/NanumSquare.ttf",
    ]
    for fp in candidates:
        if os.path.exists(fp):
            return fp
    return None

def set_matplotlib_font(font_path: str = None):
    import matplotlib
    matplotlib.rcParams["axes.unicode_minus"] = False
    if font_path and os.path.exists(font_path):
        matplotlib.rcParams["font.family"] = "sans-serif"
        matplotlib.rcParams["font.sans-serif"] = [font_path]
    else:
        # Fallback to a default; labels may show boxes if no Korean font installed.
        matplotlib.rcParams["font.family"] = ["DejaVu Sans"]

# -------------------------
# Morphological analyzer
# -------------------------
def get_analyzer():
    # prefer Okt (pure-Python/JVM), then Mecab; fallback to regex
    try:
        from konlpy.tag import Okt
        okt = Okt()
        def extract(text: str):
            return [w for (w, t) in okt.pos(text, norm=True, stem=True) if t in ("Noun", "Adjective")]
        return "KoNLPy/Okt", extract
    except Exception:
        try:
            from konlpy.tag import Mecab
            mecab = Mecab()
            def extract(text: str):
                return [w for (w, t) in mecab.pos(text) if t.startswith("NN") or t.startswith("VA")]
            return "KoNLPy/Mecab", extract
        except Exception:
            def extract(text: str):
                if not isinstance(text, str):
                    return []
                text = re.sub(r"[\\(\\[\\{].*?[\\)\\]\\}]", " ", text)
                text = re.sub(r"[^가-힣\\s]", " ", text)
                text = re.sub(r"\\s+", " ", text).strip()
                toks = [t for t in text.split() if len(t) >= 2]
                return [(t) for t in toks]  # no POS; treat all as nouns
            return "Fallback(정규식)", extract

# -------------------------
# Tokenization
# -------------------------
BASE_STOP = set("""
도시락 식단 정기 구독 구독형 정기배송 세트 구성 옵션 특가 행사 증정 사은품 무료 배송 추천 인기 베스트
국내산 수입산 냉동 냉장 간편 간편식 건강 프리미엄 오리지널 플러스 기획 정품
맛 맛있 음미 영양 칼로리 kcal 칼
ml g kg L l 팩 개 개입 입 봉 포 세트상품 박스 box BOX 세트형 구성품
혼합 모음 랜덤 선택 선택형 꾸러미 기본 일반
""".split())

BRAND_STOP = set("""
샐러디 노브랜드 오뚜기 CJ제일제당 풀무원 동원 대림 비비고 피코크 마켓컬리 코스트코 홈플러스 이마트 트레이더스 쿠팡
""".split())

UNIT_STOP = set("""
팩입 봉입 개입 인분 인용 미니 대용량 소용량 기본형 특대형 대형 소형 중형
""".split())

def load_extra_stopwords(path: str = None) -> set:
    extra = set()
    if path and os.path.exists(path):
        with open(path, "r", encoding="utf-8-sig") as f:
            for line in f:
                w = line.strip()
                if w:
                    extra.add(w)
    return extra

def clean_tokens(tokens: List[str], stopset: set) -> List[str]:
    out = []
    for t in tokens:
        if t in stopset: 
            continue
        if any(ch.isdigit() for ch in t):
            continue
        if len(t) <= 1:
            continue
        out.append(t)
    return out

# -------------------------
# N-grams & Co-occurrence
# -------------------------
def make_ngrams(tokens: List[str], n: int) -> List[str]:
    return ["".join(tokens[i:i+n]) for i in range(len(tokens)-n+1)]

def cooccurrence(tokens_docs: List[List[str]], min_freq=2):
    node = Counter()
    edge = Counter()
    for toks in tokens_docs:
        uniq = sorted(set(toks))
        node.update(uniq)
        for a, b in itertools.combinations(uniq, 2):
            edge[(a, b)] += 1
    node_df = pd.DataFrame(node.items(), columns=["토큰", "빈도"]).sort_values("빈도", ascending=False)
    edge_df = pd.DataFrame([(a, b, c) for (a, b), c in edge.items() if c >= min_freq],
                           columns=["소스", "타겟", "빈도"]).sort_values("빈도", ascending=False)
    return node_df, edge_df

# -------------------------
# TF-IDF (2 docs: Band1 vs Band2)
# -------------------------
def tfidf_two_docs(tokens_docs_A: List[List[str]], tokens_docs_B: List[List[str]]):
    def flatten(docs): 
        return " ".join([" ".join(t) for t in docs]).split()
    A = flatten(tokens_docs_A)
    B = flatten(tokens_docs_B)
    terms = sorted(set(A) | set(B))
    def vec(tokens):
        cnt = Counter(tokens); tot = sum(cnt.values()) if sum(cnt.values())>0 else 1
        vals = []
        for t in terms:
            tf = cnt.get(t, 0) / tot
            df = int(t in set(A)) + int(t in set(B))
            idf = math.log((2 + 1) / (df + 1)) + 1.0
            vals.append(tf * idf)
        return np.array(vals)
    return terms, vec(A), vec(B)

# -------------------------
# Plot helpers (WordCloud optional)
# -------------------------
def try_wordcloud(freq_df: pd.DataFrame, font_path: str, title: str, out_png: str):
    ok = False
    try:
        from wordcloud import WordCloud
        freq_dict = {r["토큰"]: int(r["빈도"]) for _, r in freq_df.iterrows()}
        wc = WordCloud(width=1200, height=800, background_color="white", font_path=font_path)
        img = wc.generate_from_frequencies(freq_dict)
        plt.figure(figsize=(10,6))
        plt.imshow(img, interpolation="bilinear")
        plt.axis("off")
        plt.title(title)
        plt.tight_layout()
        plt.savefig(out_png, dpi=200, bbox_inches="tight")
        plt.close()
        ok = True
    except Exception:
        ok = False
    return ok

def bar_top(freq_df: pd.DataFrame, title: str, out_png: str):
    top = freq_df.head(15)
    plt.figure(figsize=(8,6))
    plt.barh(top["토큰"][::-1], top["빈도"][::-1])
    plt.xlabel("빈도")
    plt.title(title)
    plt.tight_layout()
    plt.savefig(out_png, dpi=200, bbox_inches="tight")
    plt.close()

def draw_network(edge_df: pd.DataFrame, node_df: pd.DataFrame, title: str, out_png: str, top_nodes=30):
    keep = list(node_df.head(top_nodes)["토큰"])
    if not keep:
        return
    angles = np.linspace(0, 2*np.pi, len(keep), endpoint=False)
    pos = {k: (np.cos(a), np.sin(a)) for k, a in zip(keep, angles)}
    plt.figure(figsize=(9,7))
    for k,(x,y) in pos.items():
        size = 250 + 45*int(node_df.set_index("토큰").loc[k,"빈도"])
        plt.scatter([x],[y], s=size)
        plt.text(x,y,k,ha="center",va="center")
    sub = edge_df[edge_df["소스"].isin(keep) & edge_df["타겟"].isin(keep)]
    for _,r in sub.iterrows():
        x1,y1 = pos[r["소스"]]; x2,y2 = pos[r["타겟"]]
        plt.plot([x1,x2],[y1,y2], alpha=0.25)
    plt.title(title)
    plt.axis("off")
    plt.tight_layout()
    plt.savefig(out_png, dpi=200, bbox_inches="tight")
    plt.close()

# -------------------------
# Main
# -------------------------
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--summary", type=str, default="")
    ap.add_argument("--data", type=str, default="")
    ap.add_argument("--outdir", type=str, default="./out")
    ap.add_argument("--font", type=str, default=None, help="Korean TTF/OTF path (recommended for image text).")
    ap.add_argument("--stopwords", type=str, default=None, help="Extra stopwords, one per line.")
    args = ap.parse_args()

    os.makedirs(args.outdir, exist_ok=True)

    summary_path = pick_first_exist([
        args.summary,
        "스윗스팟_분석_요약_통합_최저4000제외.csv",
        "스윗스팟_분석_요약_통합.csv",
    ])
    data_path = pick_first_exist([
        args.data,
        "분석사용데이터_통합_최저4000제외.csv",
        "분석사용데이터_통합.csv",
    ])
    if not summary_path or not data_path:
        raise FileNotFoundError("요약/데이터 CSV 경로를 찾지 못했습니다. --summary / --data 옵션을 확인하세요.")

    summary_df = read_csv_u(summary_path)
    data_df = read_csv_u(data_path)

    # Font
    font_path = pick_korean_font_path(args.font)
    set_matplotlib_font(font_path)

    # Analyzer
    analyzer_name, extractor = get_analyzer()

    # Stopwords
    stopset = set()
    stopset |= BASE_STOP | BRAND_STOP | UNIT_STOP
    stopset |= load_extra_stopwords(args.stopwords)

    # Parse band ranges
    bands: Dict[str, Tuple[int,int]] = {}
    for i in (1, 2):
        row = summary_df[summary_df["밴드"] == f"Band {i}"]
        if len(row):
            L, R = parse_band_range(row.iloc[0]["구간(원)"])
            if L is not None:
                bands[f"Band {i}"] = (L, R)
    if not bands:
        raise ValueError("밴드 정보를 찾지 못했습니다. 요약 CSV의 '밴드'와 '구간(원)' 컬럼을 확인하세요.")

    # Tokenize by band
    band_docs = {}
    for band, (L,R) in bands.items():
        sub = data_df[(data_df["1회 가격"] >= L) & (data_df["1회 가격"] < R)].copy()
        docs = []
        for s in sub["상품명"].astype(str):
            toks = extractor(s)
            # when regex-fallback returns simple strings, normalize to list of strings
            toks = [w if isinstance(w, str) else str(w) for w in toks]
            toks = [t for t in toks if t not in stopset and not any(ch.isdigit() for ch in t) and len(t) > 1]
            docs.append(toks)
        band_docs[band] = docs

    # Per-band frequency & ngram
    summary_rows = []
    for band, docs in band_docs.items():
        cnt = Counter()
        for tks in docs: cnt.update(tks)
        freq_df = pd.DataFrame(cnt.most_common(100), columns=["토큰","빈도"])

        # n-grams
        bi = Counter(); tri = Counter()
        for tks in docs:
            for n in range(2,3):
                bi.update(["".join(tks[i:i+n]) for i in range(len(tks)-n+1)])
            for n in range(3,4):
                tri.update(["".join(tks[i:i+n]) for i in range(len(tks)-n+1)])
        bi_df = pd.DataFrame(bi.most_common(100), columns=["바이그램","빈도"])
        tri_df = pd.DataFrame(tri.most_common(100), columns=["트라이그램","빈도"])

        # Save CSVs (utf-8-sig)
        write_csv_u(freq_df, os.path.join(args.outdir, f"{band}_토큰빈도.csv"))
        write_csv_u(bi_df,   os.path.join(args.outdir, f"{band}_바이그램.csv"))
        write_csv_u(tri_df,  os.path.join(args.outdir, f"{band}_트라이그램.csv"))

        # Wordcloud (if available) else bar
        wc_png = os.path.join(args.outdir, f"{band}_워드클라우드.png")
        if not try_wordcloud(freq_df, font_path, f"{band} 워드클라우드", wc_png):
            bar_top(freq_df, f"{band} 토큰 상위 빈도", wc_png)

        # Co-occurrence
        node_df, edge_df = cooccurrence(docs, min_freq=2)
        write_csv_u(node_df, os.path.join(args.outdir, f"{band}_co_nodes.csv"))
        write_csv_u(edge_df, os.path.join(args.outdir, f"{band}_co_edges.csv"))
        draw_network(edge_df, node_df, f"{band} 공동등장 네트워크", os.path.join(args.outdir, f"{band}_공동등장_네트워크.png"))

        summary_rows.append({"밴드": band, "문서수": len(docs), "토큰유니크": len(node_df)})

    # TF-IDF compare
    labels = list(band_docs.keys())
    if len(labels) >= 2:
        terms, v1, v2 = tfidf_two_docs(band_docs[labels[0]], band_docs[labels[1]])
        tfidf_df = pd.DataFrame({
            "토큰": terms,
            f"{labels[0]}": v1,
            f"{labels[1]}": v2,
            "차이(B1-B2)": v1 - v2
        }).sort_values("차이(B1-B2)", ascending=False)
        write_csv_u(tfidf_df, os.path.join(args.outdir, "TFIDF_밴드비교.csv"))

        # Plot Top15
        top = tfidf_df.head(15)
        plt.figure(figsize=(8,6))
        plt.barh(top["토큰"][::-1], top["차이(B1-B2)"][::-1])
        plt.xlabel("TF-IDF 차이 (Band1 - Band2)")
        plt.title("밴드 간 TF-IDF 상대 차이 Top 15")
        plt.tight_layout()
        plt.savefig(os.path.join(args.outdir, "TFIDF_밴드비교_그래프.png"), dpi=200, bbox_inches="tight")
        plt.close()

    # Meta
    meta = pd.DataFrame([{
        "형태소 분석기": analyzer_name,
        "요약파일": os.path.basename(summary_path),
        "데이터파일": os.path.basename(data_path),
        "폰트": font_path if font_path else "Not found (fallback)",
        "추가 불용어": os.path.basename(args.stopwords) if args.stopwords else "(없음)"
    }])
    write_csv_u(meta, os.path.join(args.outdir, "메타정보.csv"))

    print(f"[DONE] outdir = {os.path.abspath(args.outdir)}")

if __name__ == "__main__":
    main()
