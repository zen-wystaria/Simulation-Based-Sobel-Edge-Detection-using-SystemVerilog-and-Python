# 🖼️ Sobel Edge Detection — Hardware–Software Co-Design

A simulation-based image processing pipeline using **Python** and **SystemVerilog** — from raw image to edge-detected output via RTL convolution.

---

## 📌 Overview

This project demonstrates how a classical image processing algorithm can be split between software and hardware-style logic. Python handles image preprocessing and reconstruction; the Sobel convolution kernel is implemented in SystemVerilog RTL and simulated on EDA Playground.

```
Image → Grayscale Matrix → RTL Sobel Filter → Edge-Detected Image
```

---

## 🖼️ Example Output

| Input Image (90×90) | Edge Detected Output (90×90) |
|:---:|:---:|
| ![Input](/lena_crop.png) | ![Output](/lena_edge_detected_output.png) |

---

## 🏗️ System Architecture

```
lena_crop.png
    ↓
Python Preprocessing (NumPy + OpenCV)
    ↓
integer_matrix.txt
    ↓
SystemVerilog Sobel Filter (EDA Playground Simulation)
    ↓
edge_map.txt
    ↓
Python Reconstruction (Matplotlib)
    ↓
Final Edge-Detected Image
```

---

## 📁 Project Structure

```
sobel-edge-detection/
│
├── images/
│   ├── lena_crop.png                  # Original 90×90 input image
│   └── lena_edge_detected_output.png  # Final edge-detected output
│
├── python/
│   └── sobel_final.ipynb              # Colab notebook (preprocessing + reconstruction)
│
├── verilog/
│   ├── design.sv                      # SystemVerilog Sobel filter
│   └── sobel_filter_tb.sv             # Testbench for simulation
│
├── data/
│   ├── integer_matrix.txt             # Matrix generated from input image
│   └── edge_map.txt                   # Output matrix from RTL simulation
│
└── README.md
```

---

## ⚙️ Pipeline Stages

### Stage 1 — Image Preprocessing `(Python / Google Colab)`

- Loads `lena_crop.png` using OpenCV
- Converts BGR image to grayscale
- Exports a 90×90 integer pixel matrix to `integer_matrix.txt`

> **Libraries:** `NumPy`, `OpenCV`, `Matplotlib`

---

### Stage 2 — Sobel Filter Implementation `(SystemVerilog)`

File: `design.sv` — runs on [EDA Playground](https://edaplayground.com/x/Akj8)

Two convolution kernels applied per pixel:

**Horizontal (Gx):**
```
-1  0  1
-2  0  2
-1  0  1
```

**Vertical (Gy):**
```
-1 -2 -1
 0  0  0
 1  2  1
```

Gradient magnitude per pixel:

```
G = sqrt(Gx² + Gy²)   →   clamped to [0, 255]
```

| Signal | Description |
|---|---|
| Input | 90×90 grayscale matrix, clock, reset |
| Output | 90×90 edge map matrix |

---

### Stage 3 — RTL Simulation `(EDA Playground)`

File: `sobel_filter_tb.sv`

The testbench:
1. Opens `integer_matrix.txt` and loads all 90×90 pixel values
2. Drives the Sobel filter module with a clock and reset
3. Runs the convolution computation
4. Prints the resulting edge map → saved as `edge_map.txt`

🔗 **[Run on EDA Playground](https://edaplayground.com/x/Akj8)**

---

### Stage 4 — Image Reconstruction `(Python)`

- Loads `edge_map.txt` using NumPy
- Converts matrix to `uint8`
- Renders and saves the final edge-detected image via Matplotlib

---

## 🛠️ Tools Used

| Side | Tools |
|---|---|
| **Software** | Python 3, NumPy, OpenCV, Matplotlib, Google Colab |
| **Hardware / RTL** | SystemVerilog, EDA Playground |

---

## ⚠️ Synthesizability Note

The current RTL design is written for **simulation only**. Constructs not suitable for FPGA synthesis include:

- Full-image processing in a single clock cycle (nested loops)
- Real-number operations (`sqrt`)
- Large multidimensional arrays as module ports

**For FPGA deployment, the architecture would need:**
- Streaming pixel processing with line buffers
- Sliding window 3×3 convolution
- Fixed-point arithmetic
- Pipelined datapath for real-time throughput

---

## 🧠 Concepts Demonstrated

| Domain | Topics |
|---|---|
| **Image Processing** | Sobel algorithm, gradient magnitude, grayscale conversion |
| **Python** | Matrix representation, NumPy, OpenCV, file I/O |
| **RTL Design** | SystemVerilog convolution, clocked design, reset logic |
| **Verification** | Testbench-driven simulation, file-based data exchange |
| **HW-SW Co-Design** | Software preprocessing feeding hardware simulation |

---

## 💡 Key Takeaway

> A classical CV algorithm decomposed across software and RTL — demonstrating the conceptual foundation of hardware image processing accelerators.

```
Python  →  Preprocessing & Reconstruction
Verilog →  Convolution Kernel (RTL)
```
