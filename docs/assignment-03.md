# Assignment 03: Git Conflict, Rebase and Reflog

```bash
apple@APPLEs-MacBook-Pro ILA % git status
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
apple@APPLEs-MacBook-Pro ILA % git checkout -b Asgn-03-feature-A
Switched to a new branch 'Asgn-03-feature-A'
apple@APPLEs-MacBook-Pro ILA % echo "Feature A implementation" > app.txt
apple@APPLEs-MacBook-Pro ILA % git add .
apple@APPLEs-MacBook-Pro ILA % git commit -am "Add feature A" 
[Asgn-03-feature-A 9433037] Add feature A
 1 file changed, 1 insertion(+)
 create mode 100644 app.txt
apple@APPLEs-MacBook-Pro ILA % git checkout main
Switched to branch 'main'
Your branch is up to date with 'origin/main'.
apple@APPLEs-MacBook-Pro ILA % git checkout -b Asgn-03-feature-B
Switched to a new branch 'Asgn-03-feature-B'
apple@APPLEs-MacBook-Pro ILA % echo "Feature B implementation" > app.txt
apple@APPLEs-MacBook-Pro ILA % git add .
apple@APPLEs-MacBook-Pro ILA % git commit -am "Add feature B"           
[Asgn-03-feature-B 9c8d5ed] Add feature B
 1 file changed, 1 insertion(+)
 create mode 100644 app.txt
apple@APPLEs-MacBook-Pro ILA % git rebase Asgn-03-feature-A
Auto-merging app.txt
CONFLICT (add/add): Merge conflict in app.txt
error: could not apply 9c8d5ed... Add feature B
hint: Resolve all conflicts manually, mark them as resolved with
hint: "git add/rm <conflicted_files>", then run "git rebase --continue".
hint: You can instead skip this commit: run "git rebase --skip".
hint: To abort and get back to the state before "git rebase", run "git rebase --abort".
Could not apply 9c8d5ed... Add feature B
apple@APPLEs-MacBook-Pro ILA % git rebase --continue
[detached HEAD 55f75f0] Add feature B
 1 file changed, 1 insertion(+)
Successfully rebased and updated refs/heads/Asgn-03-feature-B.
apple@APPLEs-MacBook-Pro ILA % echo "Temporary change" >> app.txt
apple@APPLEs-MacBook-Pro ILA % git add .
apple@APPLEs-MacBook-Pro ILA % git commit -am "Temporary commit"
[Asgn-03-feature-B 278e2e2] Temporary commit
 1 file changed, 1 insertion(+)
apple@APPLEs-MacBook-Pro ILA % git reset --hard HEAD~1
HEAD is now at 55f75f0 Add feature B
apple@APPLEs-MacBook-Pro ILA % git reflog
55f75f0 (HEAD -> Asgn-03-feature-B) HEAD@{0}: reset: moving to HEAD~1
278e2e2 HEAD@{1}: commit: Temporary commit
55f75f0 (HEAD -> Asgn-03-feature-B) HEAD@{2}: rebase (finish): returning to refs/heads/Asgn-03-feature-B
55f75f0 (HEAD -> Asgn-03-feature-B) HEAD@{3}: rebase (continue): Add feature B
9433037 (Asgn-03-feature-A) HEAD@{4}: rebase (start): checkout Asgn-03-feature-A
9c8d5ed HEAD@{5}: commit: Add feature B
7950c3f (origin/main, main) HEAD@{6}: checkout: moving from main to Asgn-03-feature-B
7950c3f (origin/main, main) HEAD@{7}: checkout: moving from Asgn-03-feature-A to main
9433037 (Asgn-03-feature-A) HEAD@{8}: commit: Add feature A
7950c3f (origin/main, main) HEAD@{9}: checkout: moving from main to Asgn-03-feature-A
7950c3f (origin/main, main) HEAD@{10}: pull: Fast-forward
apple@APPLEs-MacBook-Pro ILA % git log --oneline --graph --all
* 996ee5e (HEAD -> Asgn-03-feature-B) Temporary commit
* 55f75f0 Add feature B
* 9433037 (Asgn-03-feature-A) Add feature A
*   7950c3f (origin/main, main) Merge pull request #1 from Shashank-iksha/Asgn-02
|\  
| * 087f99f (origin/Asgn-02, Asgn-02) add docs
| * 6d7cf2b Add safe cleanup and development status scripts
|/  
* b71d9ad (origin/Asgn-01, Asgn-01) Asgn-01-updated-doc
* e6d49a9 Asgn-01-add-docs-scripts
* da2c323 Asgn-01-add-env
* ebf7040 Asgn-01-add-env
* 7727ce2 Asgn-01-fix-cors
* 5f3ba3a Asgn-01-fix-cors
* 2c7d8ff Asgn-01-update-frontend-for-health
* cbe8ab1 Asgn-01-Setup-vite-react-app
* 09ba233 Asgn-01-Add-gemfile
* c888882 Asgn-01-Initialize Rails backend application with essential configurations
* 8512c59 Asgn-01-add-guidelines
* b2425d6 Asgn-01-add version details
* 4c140a9 Asgn-01-initialise-repo
apple@APPLEs-MacBook-Pro ILA % %
```

## Branch Strategy Notes

- Feature branches created from main
- Rebase used to keep linear history
- Conflicts resolved locally before merging
- Reflog used for recovering lost commits

To visualize graph better:

```bash
git log --oneline --graph --decorate --all
```
