# Workstation & Repository Setup

This guide ensures every Loud Labs machine has the Contextual repo in the right place with the right
remotes before anyone opens Xcode. The generated `Contextual.xcodeproj` now lives inside the repo, so
once the clone is complete you can open it immediately in Finder or Xcode.

## 1. Prepare the folder structure

> 🆕 To run any of the commands below, open **Terminal** (`⌘` + Space → type “Terminal” → Return).
> When you see a prompt like `yourname@Mac ~ %`, copy each command, paste it into Terminal, and
> press Return to execute it. The prompt will reappear when the command has finished.

1. In Finder or Terminal, create the developer workspace if it does not already exist:
   ```sh
   mkdir -p ~/04_Developer
   ```
2. Inside that workspace, keep the Contextual repo at `~/04_Developer/Contextual`. Other Loud Labs
   repos can live alongside it (e.g., `~/04_Developer/contextual-server`). Do **not** create the
   `Contextual` subfolders manually—`git clone` will do it for you.

Keeping a consistent root path means scripts, build artifacts, and docs can assume the same
structure across the team and on automation boxes.

## 2. Clone the GitHub repository

1. Ensure you have access to <https://github.com/loudkatie/Contextual>.
2. Clone into the prepared folder:
   ```sh
   cd ~/04_Developer
   git clone git@github.com:loudkatie/Contextual.git
   ```
   > If you prefer HTTPS, swap in `https://github.com/loudkatie/Contextual.git`.
   >
   > The first time you connect to GitHub over SSH, Terminal will ask `Are you sure you want to
   > continue connecting (yes/no/[fingerprint])?`. Type `yes` and press Return so your Mac can trust
   > GitHub’s host fingerprint going forward.
   >
   > If Git reports that `~/04_Developer/Contextual` already exists from an earlier attempt, remove
   > the placeholder directory and try again:
   > ```sh
   > rm -rf ~/04_Developer/Contextual
   > git clone git@github.com:loudkatie/Contextual.git
   > ```
3. Verify the remote is present:
   ```sh
   cd Contextual
   git remote -v
   ```

## 3. Bootstrap the iOS project

1. Open the committed project (Finder path `~/04_Developer/Contextual/ios/ContextualApp/Contextual.xcodeproj`).
   Double-clicking it will launch Xcode with the ambient listening orb ready to run.
2. (Optional) Install [XcodeGen](https://github.com/yonaskolb/XcodeGen) if you plan to edit
   `project.yml`:
   ```sh
   brew install xcodegen
   ```
   With XcodeGen installed you can run `./scripts/bootstrap.sh` at any time to regenerate the project
   from the spec. The script safely skips regeneration when XcodeGen is missing.

## 4. Keep your fork aligned (optional)

If you collaborate via personal forks, add them as additional remotes:
```sh
git remote add personal git@github.com:<username>/Contextual.git
```
Use `git fetch --all` regularly and rebase your branches before opening pull requests.

---

For quick setup on a new machine, run `scripts/bootstrap.sh`. It automates the directory creation,
clone, and Xcode project generation steps described above.
