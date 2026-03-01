# Financial Analytics [FINLYTS CO2] 

## Fama-French 5-Factor Model Evaluation

### Group 2

| Name | Email |
| :--- | :--- |
| ABRIL, JEHAN | [jehan_abril@dlsu.edu.ph](mailto:jehan_abril@dlsu.edu.ph) |
| GO, KEIRA LEY ARCALA | [keira_go@dlsu.edu.ph](mailto:keira_go@dlsu.edu.ph) |
| SISON, AARON JOSHUA ESTACIO | [aaron_sison@dlsu.edu.ph](mailto:aaron_sison@dlsu.edu.ph) |
| VALENCIA, CARLOS MARTIN BELANGEL | [carlos_valencia@dlsu.edu.ph](mailto:carlos_valencia@dlsu.edu.ph) |

## Project Overview
This project involves a rigorous evaluation of the **Fama-French 5-Factor Model** using R. The model extends the Capital Asset Pricing Model (CAPM) by incorporating Size, Value, Profitability, and Investment factors alongside standard market risk. The core objective is to determine the efficacy of these five factors in explaining the excess returns of a portfolio comprising eight selected assets.

- **Primary Data Source:** [Kenneth French Data Library (202412 Archive)](https://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library_202412_archive.html?fbclid=IwY2xjawQQ7_VleHRuA2FlbQIxMABicmlkETFsSFNsRW9xUzFERHV0Mmphc3J0YwZhcHBfaWQQMjIyMDM5MTc4ODIwMDg5MgABHhCyNmhvsra8VKQbzTAyF44hmQnhpTS1HayGqPx4nJFkfgL3PNoSgsHpVOy3_aem_4hRBx0knAjCHkzPbw_raSQ)
- **Lecture Baseline:** [Financial Analytics CO2 Lecture](https://youtu.be/RPvvnNdwgBo?si=kGSzqJF13dZCSI0m)

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
```text
/
├── data/           # Kenneth French CSVs & Asset Data Sets
├── scripts/        # Raw .R scripts (Preprocessing/Analysis)
├── output/         # Final PDF/HTML Deliverables (Everything we will submit)
├── README.md       # Project Documentation (Guide about the project for groupmates)
├── .gitignore      # File to tell Git which files to ignore (don't upload)
└── project.Rmd     # Main Reproducible RMarkdown (RMD)
```

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
- **Environment:** RStudio / RMarkdown
- **Key Libraries:** `tidyquant`, `quantmod`, `tidyverse`, `broom`, `PerformanceAnalytics`.
- **Reference Management:** BibTeX (APA7 Style).

---

### Project Roadmap & Task Allocation

| Task Title | Role Assigned | Research Section | Description |
| :--- | :--- | :--- | :--- |
| **Factor Theory & Research** | Researcher | **I** | Summary of 5-factor model, theoretical significance, and impact on risk/portfolio management. |
| **Asset Selection & Tilt** | Data Specialist | **II** | Select 8 assets with explicit tilts toward SMB, HML, RMW, CMA. Provide justification for each. |
| **Descriptive Statistics** | Data Specialist | **II** | Calculate mean, median, SD, min, max, skewness, and kurtosis for all 8 assets. |
| **R Model Implementation** | Programmer | **II** | Factor ingestion, data alignment, and multivariate regression execution. |
| **Results, Discussion & Analysis** | Programmer & Researcher | **III** | Generate ggplot2 charts (rolling beta, bar charts) and interpret coefficients. |
| **Synthesis & Conclusion** | Researcher | **IV** | Relate empirical findings to theory and practical investment implications. |
| **Final Assembly & QC** | Compiler | **Deliverables** | RMD compilation, BibTeX audit, and formatting for submission. |

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

# GitHub & R Guide

If you have never used GitHub or the Command Line, follow this exactly. Do not skip steps.

## 1. Get Access (Crucial!)
Before you can see or download the files, you need permission.
1.  **Send your GitHub Username** to the Project Owner (Aaron).
2.  **Check your Email:** You will receive an invitation from GitHub.
3.  **Click "Accept Invitation":** You must do this, or the next steps will fail.

> Example of a invite: ![1772364545697](image/README/1772364545697.png)


## 2. Initial Setup (The "Automated" Way)
If you haven't set up GitHub on your computer yet, use these scripts to do it automatically (otherwise skip to next step).
1.  Go to this link: [sakudiff/tutorials-for-friends](https://github.com/sakudiff/tutorials-for-friends/tree/658f314237f379e4dcefa59a659ab22ed0d6c593/r-setup)
2.  Download the file for your OS:
    *   **MacOS:** `setup-mac.sh`
    *   **Windows:** `setup-windows.ps1`
3.  Run the script and follow the prompts. This installs everything you need.

## 3. Login to GitHub in RStudio
Open **RStudio** and look for the **Terminal** tab (usually next to the Console). Type this and press Enter:
```bash
gh auth login
```
![1772364084193](image/README/1772364084193.png)

*   **What should be your preferred protocol?** Select `HTTPS`.
*   **Authenticate Git with your GitHub credentials?** Select `Yes`.
*   **How would you like to authenticate?** Select `Login with a web browser`.
*   Copy the code shown, press Enter to open your browser, and paste the code.

## 4. Understanding Branches (The "Google Docs" Analogy)
Think of this project like a Google Doc:
*   **The Repository:** The whole Google Doc folder.
*   **The `main` Branch:** This is the **Final Printed Version**. We don't touch this until the very end. 
*   **The `draft` Branch:** This is like a **Working Tab** in a spreadsheet or a "Version 1" copy. We do ALL our work here.
*   **Cloning:** This is like clicking "Make a Copy" so you have it on your own computer.

## 5. Cloning the Repo (Getting the Files)
1.  In the RStudio Terminal, navigate to where you keep your code (e.g., `Documents`):
    ```bash
    cd ~/Documents
    ```
2.  Run the clone command:
    ```bash
    gh repo clone https://github.com/sakudiff/FINLYTS-Group-2.git
    ```
3.  In RStudio: `File -> Open Project...` -> Navigate to the `FINLYTS-Group-2` folder -> Open the `.Rproj` file.

## 6. Daily Workflow (How to Work)
**Crucial:** Always make sure you are in the `draft` "tab" before working.

### Step 1: Switch to the Draft Branch
```bash
git checkout draft
```

### Step 2: Get Latest Changes (Sync)
It's like hitting "Refresh" on a Google Doc to see what others wrote:
```bash
git pull origin draft
```

### Step 3: Make your edits
Edit your `.qmd / .rmd` or `.R` files in RStudio. Save them normally.

### Step 4: Save to GitHub (Commit & Push)
This is like "Saving a Version" so others can see it:
```bash
git add .
git commit -m "Added my section on asset selection"
git push origin draft
```

> **Note:** If you check the website on the `main` view, your changes **won't show up**. You have to switch the branch toggle on GitHub from `main` to `draft` to see your work. We keep them separate so we don't accidentally ruin the final submission.

![1772363877341](image/README/1772363877341.png)

## 7. Rendering to PDF
To turn your `.qmd` or `.rmd` files into professional PDFs, run this in your **R Console**:
```R
install.packages("tinytex")
tinytex::install_tinytex()
```
Once done, just click the **Render** button at the top of your RStudio editor.

---
