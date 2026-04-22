## R CMD check results

Local `R CMD check --no-manual`:

0 errors | 0 warnings | 0 notes

GitHub Actions `R-CMD-check` on commit
`c20d1b318251eb20f9f2000b6664d60b8fbdae0c`:

0 errors | 0 warnings | 0 notes

GitHub Actions `CRAN preflight` on commit
`c20d1b318251eb20f9f2000b6664d60b8fbdae0c`:

0 errors | 0 warnings | 0 notes

The local `R CMD check --as-cran` command was also run. Package checks passed,
but the local environment could not complete CRAN incoming URL checks because DNS
resolution was unavailable, and could not build the PDF manual because
`pdflatex` is not installed. The GitHub Actions CRAN preflight run covers those
environment-dependent checks in an environment with internet access and LaTeX
support.

## Test environments

* Local macOS, R 4.2.3
* GitHub Actions configured for macOS latest, Windows latest, Ubuntu latest,
  R release
* GitHub Actions manual CRAN preflight, Ubuntu latest, R devel

## Submission notes

This is a CRAN-targeted release candidate used to verify package metadata,
examples, mocked HTTP behavior, parser robustness, and test behavior before
first CRAN submission.

Use `CRAN-SUBMISSION.md` as the final release checklist.

The package wraps selected 'OKX' REST API endpoints. Runnable examples and tests
do not require live credentials, do not call live trading endpoints, and do not
perform account side effects.

## Reverse dependencies

There are no reverse dependencies because this package is not yet on CRAN.
