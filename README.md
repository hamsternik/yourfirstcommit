# 🥇 Your First Commit

The web app displays GitHub repo history starting from the very first commit. (yeah, in ascending order)

## The Blueprint

The project divided by several steps:

- Proof of concept (PoC)
- Product requirements document (PRD)
- Minimal viable product (MVP) v1.0.0

## Proof of Concept

The concept goal is only to show the project's very first commit. We are going to use original GitHub web site. Implementation of the commit's code changes is out of scope for the PoC. Please wait until the PRD would be fulfilled and the set of requirements would be finalized.

### Goals

- Main page with the search bar in the middle of the web page. As example look at the npm.io or npms.io.
- User is able to enter a GitHub repo URL in the search bar.
- Display the list of first N projects aligned with the user input.
- Open the GitHub repository's web page with the first commit of the selected project.
- Support only open-source projects. PoC will not support GitHub user authentication to open any private repos visible for concrete user account.

### Tech Specification

#### Web

Next.js, TypeScript. Single page application with the redirection to the GitHub web site by the project URL.

#### iOS

Swift 5+, SwiftUI, Async / Await, Combine. iOS only app. The application launch state contains only the navigation bar & search bar in the top. When the user enters any char in the search bar the client is going to request data from the GitHub. Then display the result as the list of N first repos that are provided in the response. Clicking on the repo will open the Safari in-app browser with the first commit of the selected repository.

### Design & Implementation

- Figma Design, npm.io main page: https://www.figma.com/file/1yMsW7w1xXs5K7B3NAhWFA/Your-First-Commit.io-Project?node-id=0%3A1
- npms.io website repo: https://github.com/npms-io/npms-www
