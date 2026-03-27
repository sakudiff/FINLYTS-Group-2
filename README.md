# Financial Analytics [FINLYTS CO2]

> [!IMPORTANT]
> **Live Interactive Dashboard:** [case1group2finlyts.netlify.app](https://case1group2finlyts.netlify.app/)  
> **GitHub Repository:** [github.com/sakudiff/FINLYTS-Group-2](https://github.com/sakudiff/FINLYTS-Group-2)  
> **Final Paper (PDF):** [Final_Paper_Latex/Final_Paper.pdf](Final_Paper_Latex/Final_Paper.pdf)

## Fama-French 5-Factor Model Evaluation

### Group 2
**Authors:** ABRIL, Jehan | GO, Keira Ley Arcala | SISON, Aaron Joshua Estacio | VALENCIA, Carlos Martin Belangel  
**Institution:** De La Salle University | **Course:** Financial Analytics (FINLYTS)  
**Date:** March 1, 2026

---

## Quick Navigation
*   [**Project Overview**](#project-overview) - High-level goals and data sources.
*   [**Directory Map**](#directory-map) - Where to find specific files.
*   [**Research Outline**](#research-outline) - The 4-part academic structure.
*   [**Setup Guide**](#setup-guide) - R and RStudio installation (Start here for new users).
*   [**LaTeX Guide**](#working-with-latex-tex) - Instructions for editing the final paper.

---

## Project Overview
This project involves a rigorous evaluation of the **Fama-French 5-Factor Model** using R. The model extends the Capital Asset Pricing Model (CAPM) by incorporating Size, Value, Profitability, and Investment factors alongside standard market risk. The core objective is to determine the efficacy of these five factors in explaining the excess returns of a portfolio comprising eight selected assets.

- **Primary Data Source:** [Kenneth French Data Library](https://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html)
- **Lecture Baseline:** [Financial Analytics CO2 Lecture](https://youtu.be/RPvvnNdwgBo?si=kGSzqJF13dZCSI0m)
- **Interactive Dashboard:** [case1group2finlyts.netlify.app](https://case1group2finlyts.netlify.app/)

## Objectives
- **Empirical Analysis:** Assess how well the five factors (Market, SMB, HML, RMW, CMA) explain asset returns.
- **Statistical Interpretation:** Analyze alpha and beta coefficients for statistical significance and economic meaning.
- **Technical Implementation:** Execute a reproducible R workflow utilizing the Kenneth French data library.
- **Theoretical Justification:** Provide academic grounding for asset selection and factor exposure.

## Final Deliverables (Point 7: Quality & Organization)
| Deliverable | Format/Description |
| :--- | :--- |
| **Reproducible Master Document** | Well-organized RMarkdown (.Rmd) file (HTML, PDF, or Word). |
| **Data Package** | CSV files containing historical asset data. |
| **Reference Management** | BibTeX (.bib) file for academic citations. |
| **Code Audit** | Full R code integrated into the narrative or technical appendix. |

## Directory Map

| Title & Link | Description | Purpose |
| :--- | :--- | :--- |
| [**data/**](data/) | Raw CSV files from Kenneth French & Yahoo Finance. | Source data for all quantitative models. |
| [**image/**](image/) | Plots, logos, and screenshots. | Visual assets for the README and the final paper. |
| [**Final_Paper_Latex/**](Final_Paper_Latex/) | LaTeX source files (`.tex`) and BibTeX references (`.bib`). | The production environment for the formal academic report. |
| [**Calculations.Rmd**](Calculations.Rmd) | The primary RMarkdown execution script. | Handles data cleaning, regression analysis, and plot generation. Renders to [index.html](index.html). |
| [**index.html**](index.html) | Rendered HTML output of Calculations.Rmd. | Interactive web dashboard with all analysis and visualizations. |
| [**README.md**](README.md) | This documentation file. | Project roadmap, setup guide, and technical reference. |
| [**.gitignore**](.gitignore) | Version control exclusion list. | Prevents system junk and local R history from cluttering the repo. |

## Workflow & Deliverables
*   **Calculations & Visuals:** All data processing, factor modeling, and plot generation are handled in `Calculations.Rmd`.
*   **Final Paper:** The formal academic report is maintained in `Final_Paper_Latex/Final_Paper.tex`. Results and plots from the R analysis are exported and integrated here for the final PDF submission.
*   **Interactive Dashboard:** The rendered HTML output (`index.html`) is deployed at [case1group2finlyts.netlify.app](https://case1group2finlyts.netlify.app/).


> [!TIP]
> **What is a `.gitignore`?**  
> Think of it like a **"Private Notes"** section in a Google Doc that only you can see. It tells Git which files should stay on your computer and **not** be uploaded to the shared project folder. 
> 
> **Commonly ignored files:**
> *   **RStudio Junk:** `.Rhistory`, `.RData`, and `.Rproj.user` folders.
> *   **System Trash:** `.DS_Store` (Mac) or `Thumbs.db` (Windows).
> *   **Draft Artifacts:** Temporary files created when you "Render" your PDF/HTML.
> 
> This keeps the workspace clean for everyone else and prevents "sync errors" caused by personal settings.

## Technical Stack
- **Language:** R
- **Environment:** RStudio / RMarkdown / LaTeX
- **Key Libraries:** `tidyquant`, `quantmod`, `tidyverse`, `broom`, `PerformanceAnalytics`.
- **Reference Management:** BibTeX (APA7 Style).

---

### Project Roadmap & Task Allocation

| Task Title | Role Assigned | Research Section | Description |
| :--- | :--- | :--- | :--- |
| **Factor Theory & Research** | Theory & Writing | **I** | Summary of 5-factor model, theoretical significance, and impact on risk/portfolio management. |
| **Asset Selection & Tilt** | Data & Stats | **II** | Select 8 assets with explicit tilts toward SMB, HML, RMW, CMA. Provide justification for each. |
| **Descriptive Statistics** | Data & Stats | **II** | Calculate mean, median, SD, min, max, skewness, and kurtosis for all 8 assets. |
| **R Model Implementation** | R Analysis | **II** | Factor ingestion, data alignment, and multivariate regression execution. |
| **Results, Discussion & Analysis** | R Analysis & Theory | **III** | Generate ggplot2 charts (rolling beta, bar charts) and interpret coefficients. |
| **Synthesis & Conclusion** | Theory & Writing | **IV** | Relate empirical findings to theory and practical investment implications. |
| **Final Assembly & QC** | Final Review | **Deliverables** | RMD compilation, BibTeX audit, and formatting for submission. |

---

## Research Outline

### I. Introduction & Theoretical Framework (Point 1: 5pts)
**Goal:** Research and summarize the Fama-French 5-Factor Model.
*   **Evolution:** Explain the transition from CAPM to the 5-Factor model.
*   **Professional Relevance:** Discuss impact on portfolio management, risk assessment, and asset pricing.
*   **Literature:** Systematic citation of journal articles and bibliography creation.

### II. Methodology & Technical Workflow (Points 2, 3, & 4: 25pts)
**Goal:** Define asset universe, analyze historical returns, and document the R workflow.
*   **Asset Selection (Point 2):** Choice of 8 assets representing tilts toward Market, SMB, HML, RMW, and CMA. Explicit justification for each selection is mandatory.
*   **Descriptive Statistics (Point 3):** Tabular presentation of Mean, Median, SD, Min, Max, Skewness, and Kurtosis. Analysis of what these metrics reveal about asset volatility and distribution.
*   **R Implementation (Point 4):** Step-by-step documentation of data preparation, merging asset returns with factor risk-premiums, and model fitting. Interpretation of coefficients within the workflow logic.

### III. Results, Discussion and Analysis (Points 5 & 6: 15pts)
**Goal:** Evaluate model performance and communicate findings through high-fidelity graphics.
*   **Coefficient Interpretation (Point 5):** Analysis of estimated factor loadings for each asset. Identification of dominant risk drivers.
*   **Visual Analytics (Point 6):** Integrated visuals go in here—use clear, labeled plots (Time Series, Scatter, Coefficient Bar Charts) to support the discussion.
*   **Theory-to-Practice:** Link empirical results to practical implications for fund managers and investors.
*   **All figures must be referenced in the text.**

### IV. Synthesis & Conclusion (Wrap-up)
**Goal:** Provide a final academic verdict on the model's efficacy for the selected portfolio.
*   **Summary of Findings:** Recap of asset behavior relative to factor tilts.
*   **Limitations:** Brief discussion of factors or anomalies not captured.
*   **Final Statement:** Closing thoughts on the model's utility in modern quantitative finance.

---

## Constraints
- **References:** Must use APA7 for all citations.
- **Reproducibility:** The RMarkdown must knit without errors; date indices between assets and factors must align precisely.
- **Lecture Baseline:** Code logic will adapt the structure demonstrated at [01:17:07] in the [Lecture Video](https://youtu.be/RPvvnNdwgBo?si=kGSzqJF13dZCSI0m).

---

# Setup Guide

This repository is now **public**. Anyone can view, clone, and learn from this project.

## Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/sakudiff/FINLYTS-Group-2.git
cd FINLYTS-Group-2
```

### 2. Open in RStudio
*   In RStudio: `File -> Open Project...` -> Navigate to the `FINLYTS-Group-2` folder -> Open the `.Rproj` file.

### 3. Install Dependencies
The `Calculations.Rmd` file will automatically install any missing packages when you render it. Alternatively, run this in your R console:
```R
install.packages(c("tidyverse", "tidyquant", "quantmod", "broom", "PerformanceAnalytics", "tinytex", "moments", "zoo", "ggrepel", "lubridate"))
tinytex::install_tinytex()  # For PDF rendering
```

### 4. Render the Analysis
Open `Calculations.Rmd` and click the **Knit** button to generate the HTML report (`index.html`).

---

# Working with LaTeX (`.tex`)
The formal academic paper is located in `Final_Paper_Latex/Final_Paper.tex`.

> [!TIP]
> **The Google Docs Analogy:**  
> Think of the **`.tex` file** as the **"Editing Mode"** in Google Docs where you type all your text and add formatting codes. The **`.pdf` file** is like the **"View Only"** or **"Print Preview"** version that everyone else sees. You cannot edit the PDF directly; you must change the `.tex` file first, then "Render" (Print) it to see the update.

### Why LaTeX?
We use LaTeX for the final report to ensure professional, academic-standard typesetting. It handles citations, mathematical formulas, and complex layouts more reliably than standard word processors.

### How to Edit
1.  **Open the file:** Navigate to `Final_Paper_Latex/Final_Paper.tex` in RStudio or any text editor (VS Code, Notepad++, etc.).
2.  **Make Changes:** Write your content directly in the `.tex` file. If you are unfamiliar with LaTeX, follow the existing structure (e.g., `\section{...}`, `\subsection{...}`).
3.  **Save:** Just save the file as you would any other.

### Common LaTeX Commands (Basics)
If you are new to LaTeX, here are the most common commands you will need:

| Action | Command / Syntax |
| :--- | :--- |
| **New Section** | `\section{Section Name}` |
| **Sub-section** | `\subsection{Subsection Name}` |
| **Bold Text** | `\textbf{your text here}` |
| **Italic Text** | `\textit{your text here}` |
| **Bullet Points** | `\begin{itemize} \item Point 1 \item Point 2 \end{itemize}` |
| **Numbered List** | `\begin{enumerate} \item Item 1 \item Item 2 \end{enumerate}` |
| **Mathematical Formulas** | `$E = mc^2$` (inline) or `\[ A = \pi r^2 \]` (centered block) |
| **Citations (BibTeX)** | `\cite{author2024}` or `\parencite{author2024}` |
| **Referencing Figures** | `Figure \ref{fig:my_plot}` |
| **Insert Image** | `\begin{figure}[h] \centering \includegraphics[width=0.8\textwidth]{path.png} \caption{...} \label{fig:1} \end{figure}` |
| **Simple Table** | `\begin{table}[h] \centering \begin{tabular}{cc} A & B \\ C & D \end{tabular} \caption{...} \label{tab:1} \end{table}` |
| **Flowcharts (TikZ)** | `\begin{tikzpicture} \node [draw] (a) {Start}; \end{tikzpicture}` |

> [!TIP]
> **For Flowcharts:** We use the `TikZ` package. It's powerful but can be complex. If you need a specific flowchart, it's often easiest to describe it to the project lead or look at existing examples in the `.tex` file to copy-paste.

> [!IMPORTANT]
> **Special Characters:** Characters like `%`, `$`, `&`, `_`, `{`, and `}` have special meanings in LaTeX. If you want to type them as text, you usually need to put a backslash before them (e.g., `\$` or `\%`).

### Citations & References (BibTeX)
We use a separate file, `Final_Paper_Latex/references.bib`, to manage our academic sources. This keeps the main paper clean.

**The Citation Workflow:**
1.  **Find the BibTeX:** On Google Scholar or any journal site, click the **"Cite"** button and select **"BibTeX"**.
2.  **Add to the `.bib` file:** Copy the code block and paste it into `Final_Paper_Latex/references.bib`. 
    *   *Example:* `@article{fama2015, title={...}, author={Fama, Eugene and French, Kenneth}, ...}`
3.  **Note the "Key":** The first word after the `{` is the **Key** (e.g., `fama2015`).
4.  **Cite in the `.tex` file:** Use the key in your paper to create the citation automatically.
    *   `\cite{fama2015}` $\rightarrow$ Fama and French (2015)
    *   `\parencite{fama2015}` $\rightarrow$ (Fama & French, 2015)

The bibliography at the end of the paper will update automatically.

### How to Render (See changes in the PDF)
To see how your changes look in the final PDF:
*   **In RStudio:** Open `Final_Paper_Latex/Final_Paper.tex` and click the **Compile** button (or press `Ctrl+Shift`+`X` / `Cmd+Shift`+`X`).
*   **Prerequisites:** Ensure you have a LaTeX distribution installed (e.g., TinyTeX via `tinytex::install_tinytex()` in R, or MiKTeX/TeXLive).
*   **Alternative:** You don't need to render it yourself. Simply **Save and Push** your changes to the repository, and the project leads can handle the rendering and verify the layout.

---

## License & Attribution
This project is open-source and available for educational purposes. If you use this code or analysis in your own work, please cite:

```bibtex
@unpublished{Abril2026,
  title = {Fama-French 5-Factor Model Evaluation},
  author = {Abril, Jehan and Go, Keira Ley Arcala and Sison, Aaron Joshua Estacio and Valencia, Carlos Martin Belangel},
  year = {2026},
  institution = {De La Salle University},
  url = {https://github.com/sakudiff/FINLYTS-Group-2}
}
```

