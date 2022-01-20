# Git Assignment

git commands were executed on a PowerShell prompt.
Created a new public git repo in my GitHub account named 888HA:

https://github.com/mashiutz/888HA

Cloning the Repo to my machine:

```language
`git clone https://github.com/mashiutz/888HA`
```

Create a new branch, create a file and add a commit:

```language
git checkout -b 888holdings
"888 Home Assignment" >> README.md
git add .\README.md
git commit -m "Created READM.md file"
```

Push the new branch with the file to the repo:

```language
git push origin 888holdings
```