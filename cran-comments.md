## R CMD check results

Local `R CMD check --no-manual`:

0 errors | 0 warnings | 0 notes

Local `R CMD check --as-cran` was also run. Package checks passed, but the local
environment could not complete CRAN incoming URL checks because DNS resolution
was unavailable, and could not build the PDF manual because `pdflatex` is not
installed.

A manual GitHub Actions CRAN preflight workflow is included to run
`R CMD check --as-cran` in an environment with internet access and LaTeX support
before first CRAN submission.

## Test environments

* Local macOS, R 4.2.3
* GitHub Actions configured for macOS latest, Windows latest, Ubuntu latest,
  R release
* GitHub Actions manual CRAN preflight configured for Ubuntu latest, R devel

## Submission notes

This is a CRAN-targeted release candidate used to verify package metadata,
examples, mocked HTTP behavior, parser robustness, and test behavior before
first CRAN submission.

Before submission, run the manual CRAN preflight workflow and update this file
with the final check results from an environment with working DNS and LaTeX.

The package wraps selected 'OKX' REST API endpoints. Runnable examples and tests
do not require live credentials, do not call live trading endpoints, and do not
perform account side effects.

## Reverse dependencies

There are no reverse dependencies because this package is not yet on CRAN.
