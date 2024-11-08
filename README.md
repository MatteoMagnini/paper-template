# Latex Paper Template for scientific papers

## Motivation
If you use github to write your scientific papers, you may want some features already at your disposal.
In particular, you may want to:
- automatic compilation of the latex code;
- automatic checks and fixes on the bibliography;
- automatic checks in order to avoid forgetting acknowledgments.

All these tasks are repetitive, boring and error-prone.
So, I decided to create this template to get rid of them.

## How to use
1. Create your new repository from this template (click on the green button "Use this template" at the top of this page).
2. Clone your new repository.
3. Open a shell in the root directory of your repository.
4. Run the following command:
```ruby rename.rb new-name```

This will rename the repository and the latex files accordingly to the new name you provided.
I strongly suggest to use the pattern `paper-xxxx-venue-topic` for the new name, where `xxxx` is the year of the conference, `venue` is the conference name, and `topic` is the topic of the paper.

## Structure
The repository is structured as follows:
```
<root directory>
├── .github/
│   └── workflows/
│       └── build-and-deploy-latex.yml (CI/CD pipeline)
├── .gitignore
├── .gitattributes
├── biblio.bib
├── bibtex_prettifier.rb (script to check and fix the bibliography)
├── check_acknowledgments.rb (script to check acknowledgments)
├── paper-xxxx-venue-topic.sty
├── paper-xxxx-venue-topic.tex
├── README.md
└── rename.rb (script to rename the repository and the latex files)
```

In particular the scripts are:
- `.github/workflows/build-and-deploy-latex.yml` is the CI/CD pipeline that compiles the latex code and deploys the pdf files.
- `bibtex_prettifier.rb` is a script that checks and fixes the bibliography.
It removes duplicates, and remove `url` if `doi` is present.
- `check_acknowledgments.rb` is a script that checks if the acknowledgments are present.
If they are not, it prints an error message and makes the CI/CD pipeline fail.
Read the `paper-xxxx-venue-topic.tex` file for more information on how to use these scripts.
- `rename.rb` is a script that renames the repository and the latex files.

## Final remarks
That's it for now!
If you have any suggestions, feel free to open an issue or a pull request.
I hope you find this template useful.
If you find this template useful, consider starring this repository 🙃