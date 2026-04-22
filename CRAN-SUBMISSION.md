# CRAN Submission Checklist

This file tracks final manual checks before the first CRAN submission. It is
kept in the repository for release management and excluded from package builds.

## Required Before Submission

1. Run the manual GitHub Actions CRAN preflight workflow on the release commit.
2. Confirm `R CMD check --as-cran` completes with no errors or warnings.
3. Confirm URL checks pass for `URL` and `BugReports` in `DESCRIPTION`.
4. Confirm the PDF manual builds successfully in an environment with LaTeX.
5. Update `cran-comments.md` with final check environments and results.
6. Review `README.md`, `NEWS.md`, and `DESCRIPTION` for release/version
   consistency.
7. Confirm no live credentials, source package tarballs, or `.Rcheck`
   directories are tracked.
8. Submit the built source package to CRAN.

## Current Known Local Limits

Local `R CMD check --as-cran` cannot fully complete on this machine because DNS
resolution for external URL checks is unavailable and `pdflatex` is not
installed. The manual CRAN preflight workflow is intended to cover those checks.
