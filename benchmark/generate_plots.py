#!/usr/bin/env python3
"""
benchmark/generate_plots.py
Publication-Grade Visualizations for Neu Empirical Evaluation
Mathematical Linguistics Group (mlG)
Generates:
- papers/fig3_benchmark.pdf (for LaTeX inclusion)
- benchmark/fig3_benchmark.png (for IDE preview)
"""

import json
import matplotlib.pyplot as plt
import numpy as np

def setup_style():
    plt.rcParams.update({
        'font.family': 'sans-serif',
        'font.sans-serif': ['Helvetica', 'Arial', 'DejaVu Sans'],
        'font.size': 9,
        'axes.labelsize': 9,
        'axes.titlesize': 10,
        'xtick.labelsize': 8,
        'ytick.labelsize': 8,
        'legend.fontsize': 8,
        'figure.titlesize': 11,
        'figure.dpi': 300,
        'lines.linewidth': 1.8,
        'lines.markersize': 5,
        'axes.grid': True,
        'grid.alpha': 0.3,
        'grid.linestyle': '--',
        'axes.edgecolor': '#333333',
        'axes.linewidth': 0.8
    })

def main():
    setup_style()
    results_path = "/Users/erickoduniyi/Desktop/mlg/neu/benchmark/results.json"
    with open(results_path, "r") as f:
        data = json.load(f)

    scales = data["metadata"]["scales"]
    neu_prims = data["neu_primitives"]
    pytorch = data["pytorch_pipeline"]
    routing = data["routing_vs_nas"]
    overhead = data["profiling_overhead"]

    # Extract series
    def get_neu_series(name):
        items = [x for x in neu_prims if x["name"] == name]
        items.sort(key=lambda x: x["n"])
        return [x["n"] for x in items], [x["latency_us"] for x in items]

    fig, axes = plt.subplots(2, 2, figsize=(7.2, 4.6))
    fig.subplots_adjust(hspace=0.32, wspace=0.28)

    # -------------------------------------------------------------------------
    # (a) Latency Scaling (Log-Log)
    # -------------------------------------------------------------------------
    ax_a = axes[0, 0]
    n_shift, lat_shift = get_neu_series("shift(1)")
    n_cover, lat_cover = get_neu_series("cover(8, 4)")
    n_comp, lat_comp = get_neu_series("complex")
    n_learn, lat_learn = get_neu_series("learn(routing+sgd)")
    pt_n = [x["n"] for x in pytorch]
    pt_lat = [x["latency_mean_us"] for x in pytorch]

    ax_a.plot(n_shift, lat_shift, 'o-', color='#1f77b4', label=r'Neu: $\mathtt{shift}$')
    ax_a.plot(n_cover, lat_cover, 's-', color='#2ca02c', label=r'Neu: $\mathtt{cover}$')
    ax_a.plot(n_comp, lat_comp, '^-', color='#9467bd', label=r'Neu: $\mathtt{complex}$')
    ax_a.plot(n_learn, lat_learn, 'd--', color='#d62728', label=r'Neu: $\mathtt{learn}$')
    ax_a.plot(pt_n, pt_lat, 'x-', color='#ff7f0e', linewidth=2.2, label='PyTorch 2.7 Pipeline')

    ax_a.set_xscale('log', base=2)
    ax_a.set_yscale('log')
    ax_a.set_xlabel('Signal Length $N$')
    ax_a.set_ylabel(r'Latency ($\mu$s)')
    ax_a.set_title('(a) Latency Scaling vs. Input Scale')
    ax_a.legend(loc='upper left', framealpha=0.9, fontsize=7)

    # -------------------------------------------------------------------------
    # (b) Throughput Scaling
    # -------------------------------------------------------------------------
    ax_b = axes[0, 1]
    n_shift, tp_shift = [x["n"] for x in neu_prims if x["name"] == "shift(1)"], [x["throughput_ks"] for x in neu_prims if x["name"] == "shift(1)"]
    n_cover, tp_cover = [x["n"] for x in neu_prims if x["name"] == "cover(8, 4)"], [x["throughput_ks"] for x in neu_prims if x["name"] == "cover(8, 4)"]
    pt_tp = [x["throughput_ks"] for x in pytorch]

    ax_b.plot(n_shift, np.array(tp_shift) / 1000.0, 'o-', color='#1f77b4', label=r'Neu: $\mathtt{shift}$')
    ax_b.plot(n_cover, np.array(tp_cover) / 1000.0, 's-', color='#2ca02c', label=r'Neu: $\mathtt{cover}$')
    ax_b.plot(pt_n, np.array(pt_tp) / 1000.0, 'x-', color='#ff7f0e', label='PyTorch 2.7 Pipeline')

    ax_b.set_xscale('log', base=2)
    ax_b.set_xlabel('Signal Length $N$')
    ax_b.set_ylabel('Throughput (MSamples / s)')
    ax_b.set_title('(b) Processing Throughput')
    ax_b.legend(loc='upper left', framealpha=0.9, fontsize=7.5)

    # -------------------------------------------------------------------------
    # (c) Representation Routing vs. NAS
    # -------------------------------------------------------------------------
    ax_c = axes[1, 0]
    methods = ['Neu: A* Routing', 'PyTorch: Mini-NAS']
    times = [routing["neu_routing_time_ms"], routing["pytorch_nas_time_ms"]]
    colors = ['#2ca02c', '#d62728']

    bars = ax_c.bar(methods, times, color=colors, width=0.45, edgecolor='#222222', alpha=0.85)
    ax_c.set_yscale('log')
    ax_c.set_ylabel('Search Latency (ms)')
    ax_c.set_title('(c) Architectural Pathfinding Latency')
    for bar in bars:
        yval = bar.get_height()
        ax_c.text(bar.get_x() + bar.get_width()/2.0, yval * 1.5, f"{yval:.3f} ms" if yval < 1 else f"{yval:.1f} ms",
                  ha='center', va='bottom', fontsize=8, fontweight='bold')

    # Annotate speedup
    speedup_text = f"{routing['speedup']:,.0f}x Faster Convergence"
    ax_c.text(0.5, 0.85, speedup_text, transform=ax_c.transAxes, ha='center',
              bbox=dict(boxstyle='round,pad=0.3', facecolor='#ffffcc', edgecolor='#888888', alpha=0.9),
              fontsize=8, fontweight='bold', color='#333333')

    # -------------------------------------------------------------------------
    # (d) Profiling Overhead (Epiplexity & Complexity)
    # -------------------------------------------------------------------------
    ax_d = axes[1, 1]
    ov_n = [x["n"] for x in overhead]
    plex_lat = [x["plex_us"] for x in overhead]
    comp_lat = [x["complex_us"] for x in overhead]
    shift_lat = [x["shift_us"] for x in overhead]

    ax_d.plot(ov_n, shift_lat, 'o-', color='#1f77b4', label=r'Baseline ($\mathtt{shift}$)')
    ax_d.plot(ov_n, comp_lat, '^-', color='#9467bd', label=r'Complex Profiler ($\mathtt{complex}$)')
    ax_d.plot(ov_n, plex_lat, 's-', color='#e377c2', label=r'Epiplexity ($\mathtt{plex}$)')

    ax_d.set_xscale('log', base=2)
    ax_d.set_yscale('log')
    ax_d.set_xlabel('Signal Length $N$')
    ax_d.set_ylabel(r'Overhead Latency ($\mu$s)')
    ax_d.set_title('(d) Information-Theoretic Profiling Cost')
    ax_d.legend(loc='upper left', framealpha=0.9, fontsize=7.5)

    # Clean layout
    plt.tight_layout()

    # Save PDF for LaTeX inclusion and PNG for preview
    pdf_path = "/Users/erickoduniyi/Desktop/mlg/neu/papers/fig3_benchmark.pdf"
    png_path = "/Users/erickoduniyi/Desktop/mlg/neu/benchmark/fig3_benchmark.png"
    plt.savefig(pdf_path, format='pdf', bbox_inches='tight')
    plt.savefig(png_path, format='png', dpi=300, bbox_inches='tight')
    print(f"[+] Exported publication figure to {pdf_path}")
    print(f"[+] Exported raster preview to {png_path}")

if __name__ == "__main__":
    main()
