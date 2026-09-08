#!/usr/bin/env python3
"""
benchmark/generate_translation_plots.py
Publication-Grade Visualizations for Neu Topological Seq2Seq Evaluation
Mathematical Linguistics Group (mlG)
Generates:
- papers/fig_seq2seq_benchmark.pdf (for LaTeX monograph)
- benchmark/fig_seq2seq_benchmark.png (for IDE preview)
"""

import json
import os
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
        'lines.markersize': 5.5,
        'axes.grid': True,
        'grid.alpha': 0.3,
        'grid.linestyle': '--',
        'axes.edgecolor': '#333333',
        'axes.linewidth': 0.8
    })

def main():
    setup_style()
    results_path = "/Users/erickoduniyi/Desktop/mlg/neu/benchmark/translation_results.json"
    with open(results_path, "r") as f:
        data = json.load(f)

    lengths = data["metadata"]["lengths"]
    pt_data = data["pytorch_results"]
    neu_data = data["neu_results"]

    pt_lat = [x["latency_mean_us"] for x in pt_data]
    pt_std = [x["latency_std_us"] for x in pt_data]
    pt_ram = [x["peak_memory_kb"] for x in pt_data]
    pt_tp  = [x["throughput_tokens"] for x in pt_data]

    neu_lat = [x["latency_mean_us"] for x in neu_data]
    neu_ram = [x["peak_memory_kb"] for x in neu_data]
    neu_tp  = [x["throughput_tokens"] for x in neu_data]

    fig, axes = plt.subplots(2, 2, figsize=(7.4, 4.8))
    fig.subplots_adjust(hspace=0.36, wspace=0.30)

    # -------------------------------------------------------------------------
    # (a) Inference Latency vs Sequence Length (Log-Log)
    # -------------------------------------------------------------------------
    ax_a = axes[0, 0]
    ax_a.errorbar(lengths, pt_lat, yerr=pt_std, fmt='s-', color='#d62728', 
                 linewidth=2.0, capsize=3, label='PyTorch 2.7 (207k Param)')
    ax_a.plot(lengths, neu_lat, 'o-', color='#1f77b4', linewidth=2.2, 
             label=r'Neu: $\mathtt{learn}\circ\mathtt{cover}\circ\mathtt{split}$')
    
    ax_a.set_xscale('log', base=2)
    ax_a.set_yscale('log')
    ax_a.set_xticks(lengths)
    ax_a.get_xaxis().set_major_formatter(plt.ScalarFormatter())
    ax_a.set_xlabel(r'Sequence Length $L$ (Tokens)')
    ax_a.set_ylabel(r'Inference Latency ($\mu$s)')
    ax_a.set_title(r'(a) Latency vs Sequence Length ($L$)', fontweight='bold')
    ax_a.legend(frameon=True, facecolor='#fcfcfc', edgecolor='#cccccc', loc='lower right')

    # Annotate speedup at L=4 and L=64
    ax_a.annotate(r'$\mathbf{29.5\times}$ speedup', xy=(4, 14.98), xytext=(4.3, 40),
                 arrowprops=dict(facecolor='#1f77b4', shrink=0.08, width=1, headwidth=4),
                 fontsize=8, fontweight='bold', color='#1f77b4')
    ax_a.annotate(r'$\mathbf{5.6\times}$ speedup', xy=(64, 112.18), xytext=(22, 170),
                 arrowprops=dict(facecolor='#1f77b4', shrink=0.08, width=1, headwidth=4),
                 fontsize=8, fontweight='bold', color='#1f77b4')

    # -------------------------------------------------------------------------
    # (b) Active Memory Footprint vs Length (Log-Log)
    # -------------------------------------------------------------------------
    ax_b = axes[0, 1]
    ax_b.plot(lengths, pt_ram, 's--', color='#d62728', linewidth=1.8, label='PyTorch Tensor Buffer')
    ax_b.plot(lengths, neu_ram, 'o-', color='#2ca02c', linewidth=2.2, label='Neu Match-Action Cache')

    ax_b.set_xscale('log', base=2)
    ax_b.set_yscale('log')
    ax_b.set_xticks(lengths)
    ax_b.get_xaxis().set_major_formatter(plt.ScalarFormatter())
    ax_b.set_xlabel(r'Sequence Length $L$ (Tokens)')
    ax_b.set_ylabel(r'Active SRAM / Buffer (KB)')
    ax_b.set_title(r'(b) Memory Allocation Footprint', fontweight='bold')
    ax_b.legend(frameon=True, facecolor='#fcfcfc', edgecolor='#cccccc', loc='center right')

    ax_b.annotate(r'$\mathbf{2,820\times}$ less RAM', xy=(4, 0.29), xytext=(4.2, 1.8),
                 arrowprops=dict(facecolor='#2ca02c', shrink=0.08, width=1, headwidth=4),
                 fontsize=8, fontweight='bold', color='#2ca02c')

    # -------------------------------------------------------------------------
    # (c) Token Throughput Scaling (Log-Linear)
    # -------------------------------------------------------------------------
    ax_c = axes[1, 0]
    ax_c.plot(lengths, [tp / 1000.0 for tp in neu_tp], 'o-', color='#1f77b4', 
             linewidth=2.2, label=r'Neu Throughput')
    ax_c.plot(lengths, [tp / 1000.0 for tp in pt_tp], 's-', color='#ff7f0e', 
             linewidth=1.8, label=r'PyTorch 2.7 Throughput')

    ax_c.set_xscale('log', base=2)
    ax_c.set_xticks(lengths)
    ax_c.get_xaxis().set_major_formatter(plt.ScalarFormatter())
    ax_c.set_xlabel(r'Sequence Length $L$ (Tokens)')
    ax_c.set_ylabel(r'Throughput ($10^3$ Tokens/sec)')
    ax_c.set_title(r'(c) Inference Throughput vs $L$', fontweight='bold')
    ax_c.legend(frameon=True, facecolor='#fcfcfc', edgecolor='#cccccc', loc='center right')

    # -------------------------------------------------------------------------
    # (d) Embedded Hardware Constraint Profile
    # -------------------------------------------------------------------------
    ax_d = axes[1, 1]
    targets = ['RP2040\n(Pico)', 'Cortex-M0+\n(Wearable)', 'Pi 4/5\n(A72)']
    
    x_indices = np.arange(len(targets))
    width = 0.32

    # Memory requirement comparison
    pytorch_mem = [817.55, 817.55, 817.55] # KB
    neu_mem     = [3.2, 0.29, 3.2]         # KB
    hw_limits   = [264.0, 32.0, 4194304.0] # Total SRAM

    b1 = ax_d.bar(x_indices - width/2, pytorch_mem, width, color='#f0a8d0', 
                 alpha=0.9, edgecolor='#b83280', linewidth=1.0, label='PyTorch Req. RAM')
    b2 = ax_d.bar(x_indices + width/2, neu_mem, width, color='#6ee7b7', 
                 alpha=0.9, edgecolor='#059669', linewidth=1.0, label='Neu Match Table')

    # Draw hardware physical limit dashed threshold lines
    ax_d.hlines(hw_limits[0], xmin=0 - width, xmax=0 + width, color='#b91c1c', 
                linestyle='--', linewidth=1.6, zorder=6)
    ax_d.text(0, 330.0, 'Limit: 264 KB', ha='center', fontsize=6.8, 
              color='#991b1b', fontweight='bold')

    ax_d.hlines(hw_limits[1], xmin=1 - width, xmax=1 + width, color='#b91c1c', 
                linestyle='--', linewidth=1.6, zorder=6)
    ax_d.text(1, 40.0, 'Limit: 32 KB', ha='center', fontsize=6.8, 
              color='#991b1b', fontweight='bold')

    # Badges for OOM and PASS
    badge_oom = dict(boxstyle='round,pad=0.25', facecolor='#fef2f2', edgecolor='#ef4444', linewidth=0.8)
    badge_pass = dict(boxstyle='round,pad=0.25', facecolor='#ecfdf5', edgecolor='#10b981', linewidth=0.8)

    ax_d.text(0 - width/2, 1700, 'OOM (3.1x)', ha='center', fontsize=7.2, 
              color='#b91c1c', fontweight='bold', bbox=badge_oom)
    ax_d.text(1 - width/2, 1700, 'OOM (25.5x)', ha='center', fontsize=7.2, 
              color='#b91c1c', fontweight='bold', bbox=badge_oom)

    ax_d.text(0 + width/2, 9.5, 'PASS (1.2%)', ha='center', fontsize=7.2, 
              color='#047857', fontweight='bold', bbox=badge_pass)
    ax_d.text(1 + width/2, 1.1, 'PASS (0.9%)', ha='center', fontsize=7.2, 
              color='#047857', fontweight='bold', bbox=badge_pass)
    ax_d.text(2 + width/2, 9.5, 'PASS (<0.1%)', ha='center', fontsize=7.2, 
              color='#047857', fontweight='bold', bbox=badge_pass)

    ax_d.set_yscale('log')
    ax_d.set_ylim(0.06, 6000)
    ax_d.set_xticks(x_indices)
    ax_d.set_xticklabels(targets)
    ax_d.set_ylabel(r'Memory Footprint (KB)')
    ax_d.set_title(r'(d) Microcontroller Feasibility', fontweight='bold')
    ax_d.legend(frameon=True, facecolor='#ffffff', edgecolor='#cccccc', loc='upper right', fontsize=7.5)

    plt.tight_layout()

    # Save to outputs
    pdf_out = "/Users/erickoduniyi/Desktop/mlg/neu/papers/fig_seq2seq_benchmark.pdf"
    png_out = "/Users/erickoduniyi/Desktop/mlg/neu/benchmark/fig_seq2seq_benchmark.png"
    os.makedirs(os.path.dirname(pdf_out), exist_ok=True)
    os.makedirs(os.path.dirname(png_out), exist_ok=True)

    fig.savefig(pdf_out, bbox_inches='tight')
    fig.savefig(png_out, bbox_inches='tight', dpi=300)
    plt.close(fig)

    print(f"[+] Saved PDF to: {pdf_out}")
    print(f"[+] Saved PNG to: {png_out}")

if __name__ == "__main__":
    main()
