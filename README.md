# Qanban Board
> The automated, dual track, project board that prioritzes results over planning.

## assumptions
To be as efficient, automated, and simple-to-use we are assuming the following:
1. Each top level project has it's own repository
1. All repositories are created through [github](https://www.github.com)
1. The repository branching pattern will fllow the rules of [gitflow](https://danielkummer.github.io/git-flow-cheatsheet/)
1. There is a top level directory named `.discovery`
    - this will be configurable in the future

> _**CAVEAT**_: it is important to note that the repositories do not have to have an online presence and can exist _solely_ on your computer's file system.

## flow
> Described in high level terms. More granular updates to follow as the build proceeds.

1. Determine
1. Discover / Develop
1. Document
1. Deploy

### determine
The initial view of the application you will find the **Project Selector**, a scrollable list of all repositories the _**Qanban Application**_ has access to.
- If applicable, the project previously used will automatically be marked as `determined`.
- Selecting any of the listed projects will mark it as `determined` and remove the status from any previously selected projects.
  - _i.e._: There can only be one project with the `determined` status at any given time.

Next to the **Project Selector** will be the **Progress Line**. This consists of a timeline with two vertically stacked bars.

> For the **Progress Line** we are taking inspiration from [this blog post](https://jpattonassociates.com/dual-track-development/), and in particular [this image](https://jpattonassociates.com/wp-content/uploads/2017/05/sy-dual-track-model.png). However, we have changed categories for the tracks to better fit the needs we have encountered.

In this app the top bar shows progress made during research, planning, processing user feedback, etc. Basically everything that needs to happen for the design and development aspects to be completed.
- This is a part of the process that I think is overlooked quite often. It is hard to track or obtain metrics from, so it is deprioritized.

The bottom bar represents the design and development aspects. The pieces of the build that are typically stored in a repository.

After marking a project as `determined` (or using the previously selected project) the state automatically updates to the next step of the process.

### discover / develop
With the _**Qanban Application**_ the tedious part of the process is virtually removed from your plate. You do _**not**_ have to create a ticket, you do _**not**_ have to drag a card, you do _**not**_ have to ensure a branch name contains a specific string to match up to some other programs external id.

> All you _**have**_ to do, is be productive.

#### how it works
##### _discover_
Begin researching, planning, deciphering feedback, or whatever is needed to advance the project. Then document your findings.

This is where the nuance lies. Your documentation needs to follow a couple of simple rules:

1. the findings need to be saved in a `.md` or `.txt` file within the top-level `.discovery` folder.
  - The **Progress Line** will parse all files in the `.discovery` directory (grouped by the creation date) and update the UI of the **Progress Line**.
1. any findings that you want a quick reference to should be contained within a markdown formatted block quote that begins with `> |REF:`
1. any findings that you want to be converted to a task visible on the **Progress Line** should be contained within a markdown formatted block quote that begins with `> |TODO:`

Following the guidelines of the above will result in something along the lines of:

• <img width="372" alt="Screenshot 2023-12-16 at 00 18 55" src="https://github.com/DownQuark-Work/downquark.applicationFoss.QanbanBoard/assets/40064794/ec3c2bd5-fc49-49e6-84b6-32bd3629d35b">

- The collapsed dot will expand to show the progress made by the developer working on the bottom bar of our application.
    - Clicking the dot will open all files that were created at that day in time.
- The pop-up will display after a very brief delay to prevent accidental openings.
    - All `> |TODO:` items will be displayed alongside a checkbox
    - Clicking the checkbox will update an internal changelog (more below) as well as display a secondary checkbox that asks if you want to remove this task from the changelog
    - All `> |REF:` items will be displayed in a scrolling area above the task list which will allow for "at-a-glance" retrieval of data deemed important at the time.

> NOTE: In the future we will support more types of tagging (like `> |BUG:` for instance).
> - `> |EXT:` as well. To track your blog posts, forum updates, or even other sites you've found interesting

##### _develop_
Even more straight forward than _discover_.

1. Each time you run `git flow feature start <FEATURE_NAME>` the _**Qanban Application**_ will create it's version of a ticket, using `<FEATURE_NAME>` as the identifier.
1. Each time you run `git flow feature finish` (with or without  `<FEATURE_NAME>`) the _**Qanban Application**_ will mark the "ticket" complete.

Following the `git flow` pattern will result in something along the lines of a sideways `git log --graph`:

• <img width="203" alt="Screenshot 2023-12-16 at 01 33 18" src="https://github.com/DownQuark-Work/downquark.applicationFoss.QanbanBoard/assets/40064794/2ff4573f-f986-4af1-bdcc-4ab14fac1605">

### document
Documentation has been being automatically created for:
1. The changelog during _discover_ tasks being completed
1. Information to be applied to a Pull Request based on the commit comments

While the text will not be perfect, it should at least change the thought process from  "I have to make this" to "let me just make a quick edit here and there"

These files are stored within a top level `.docs` directory and can be accessed and edited at any time.

### deploy
Triggered on `git flow release finish` this will append two more command line prompts, asking if you want to:
1. publish all tags
1. apply the changelog content to the release

## phew