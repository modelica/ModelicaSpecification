# Editing ModelicaSpecification with Overleaf

You can use [Overleaf](https://www.overleaf.com/) for convenient online collaborative editing of the Modelica Specification LaTeX sources.

## Getting Started

1. **Fork or Download the Repository**
   - The easiest way is to download the repository as a ZIP file or clone it to your local machine, then upload the LaTeX sources to a new Overleaf project.
   - Alternatively, if you have a paid Overleaf account, you can sync directly with GitHub.

2. **Project Structure**
   - Upload all files and folders in the repository to Overleaf to preserve cross-references and image links.
   - The main document file is `MLS.tex`, which includes all chapters via `\include{chapters/...}`.

3. **Compiling**
   - Overleaf uses a standard LaTeX compiler (pdfLaTeX). Ensure `MLS.tex` is set as the main file.
   - You may need to set the compiler to pdfLaTeX in Overleaf’s menu for best compatibility.
   - You must have a paid Overleaf account to prevent exceeeding the compiler timeout limit.

4. **Tips**
   - Overleaf may not support all custom scripts or Makefile functionality, but basic editing and compiling work well.
   - If you encounter package errors, check the `preamble.tex` for required LaTeX packages and add them via Overleaf’s package manager if needed.

5. **Collaboration**
   - Use Overleaf’s sharing feature to invite collaborators by email.
   - Changes can be tracked and merged with the GitHub repository manually if needed.

## Syncing with GitHub (Advanced)

If you want to keep your Overleaf project in sync with GitHub:

- You must have a paid Overleaf account.
- Follow Overleaf’s [GitHub integration guide](https://www.overleaf.com/learn/how-to/GitHub_Integration).
- Push changes from Overleaf to a branch or pull request in the main repo after editing.

## Notes

- For style and formatting guidelines, see [styleguide.md](styleguide.md).
- For compiling to PDF locally, see instructions in the [README.md](README.md).
- For HTML output, Overleaf does not support LaTeXML; use the local build instructions.

---

Feel free to improve or move this file into your main documentation folder, and update the README.md with a link to it.