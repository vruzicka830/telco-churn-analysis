# Predicting Customer Churn (Logistic Regression in R)

A logistic-regression analysis that predicts which telecom customers are about
to churn, and explains why they do. Everything runs in code and reproduces from
a clean clone: the data is downloaded, cleaned, explored, modeled, and scored on
a held-out test set, then written up in one rendered report.

> **Read the full analysis:** [`churn-analysis.Rmd`](churn-analysis.Rmd)
> (render it to HTML, see below, for the report with all figures).

## What's here

- A **logistic-regression** model fit to 7,032 customers, picked for
  interpretability: every driver comes with a plain-English odds ratio.
- An honest evaluation on a 25% held-out test set. It leans on ROC/AUC and the
  confusion matrix rather than accuracy, which flatters any model once the
  classes are imbalanced.
- Reproducible from a clean clone. Install the packages and render;
  `R/load_data.R` fetches and caches the data, and nothing is hand-edited.

## What it found

- **Contract type and tenure dominate.** A two-year contract cuts the odds of
  churn by about 75% against month-to-month, and risk keeps dropping the longer
  a customer stays.
- Electronic-check payment, paperless billing, multiple lines, and
  senior-citizen status each add smaller but significant risk.
- Monthly charges and fiber-optic internet *look* risky in the raw data, then
  stop being significant once tenure and total charges enter the model. The
  report digs into why (marginal vs. conditional effects).
- Pointed at the model's top-risk customers, a retention team beats random
  outreach by a wide margin (test-set **AUC ≈ 0.84**).

## Tech stack

`R` · `tidyverse` (dplyr, ggplot2, tidyr) · `broom` · `pROC` · `R Markdown`

## Repository layout

```
telco-churn-analysis/
├── README.md              # you are here
├── churn-analysis.Rmd     # the full analysis + write-up
├── R/
│   └── load_data.R        # reproducible download + cleaning
└── data/                  # auto-downloaded cache (git-ignored)
```

## Reproduce it

```bash
# 1. Install the R packages used here (one time)
Rscript -e 'install.packages(c("tidyverse","broom","pROC","scales","rmarkdown"))'

# 2. Render the report to a self-contained HTML file
Rscript -e 'rmarkdown::render("churn-analysis.Rmd")'
# -> opens as churn-analysis.html
```

Rendering requires [`pandoc`](https://pandoc.org/installing.html) (bundled with
RStudio; on Ubuntu: `sudo apt install pandoc`).

## Data

[Telco Customer Churn](https://www.kaggle.com/datasets/blastchar/telco-customer-churn)
is a widely used public dataset of telecom customer accounts and whether each
customer churned. Fetched automatically from a public mirror at runtime.

## About

A portfolio piece. The point is to show a full modeling workflow in R, from a
raw CSV to a write-up a non-technical reader can follow, with the evaluation
done carefully rather than glossed over.
