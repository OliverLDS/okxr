## R CMD check results

Local `R CMD check --no-manual`:

0 errors | 0 warnings | 0 notes

Local `R CMD check --as-cran` was also run. Package checks passed, but the local
environment could not complete CRAN incoming URL checks because DNS resolution
was unavailable, and could not build the PDF manual because `pdflatex` is not
installed. These environment limitations should be resolved before first CRAN
submission.

## Test environments

* Local macOS, R 4.2.3
* GitHub Actions configured for macOS latest, Windows latest, Ubuntu latest,
  R release

## Submission notes

This is a pre-CRAN GitHub release used to harden package metadata, examples,
mocked HTTP behavior, parser robustness, and test behavior before first CRAN
submission.

The package wraps selected 'OKX' REST API endpoints. Runnable examples and tests
do not require live credentials, do not call live trading endpoints, and do not
perform account side effects.

## Reverse dependencies

There are no reverse dependencies because this package is not yet on CRAN.
