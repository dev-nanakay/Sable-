# SAC Wallet Software Specification

# 1. Purpose

The goal of this project is to provide the world’s first black empowerment crypto token to be used in business, non-profits, and within black families everywhere. We call it Sable Assent Coin, shown as “SAC1” on the exchanges.

# 2. Scope 

We are a digital currency platform that embraces and supports the economic systems of the black community. Sable Assent Coin can be utilized by logging into the web wallet dashboard. This wallet dashboard interface can be used on all devices through the web interface as it will host our decentralized mobile wallet application available for both iOS as well as Android devices.

# 3. Product Perspective: System Interfaces

Public SAC1 users can use a third party wallet to transact SAC1 minted coins. Private SAC2 token requires the use of our custom wallet (SAC Wallet) to make transactions within our private blockchain node network we call the SableNet. This decentralized network is made up of nodes owned and administered by Token Ambassadors. They sign transactions on the SableNet using the Proof-of-Authority (POA) mining protocol.

The SAC Wallet allows users access to the public coins listed on reputable exchanges, and importantly the ability to trade coins and tokens within the wallet to gain access to our private marketplace of business vendors.

The blockchain network would be a private consortium of nodes located with our Token Ambassadors around the world. The Token Ambassador will have to be verified in order to purchase their own prefabricated node. Nodes achieve consensus by connecting to a central node validation server administered by the Sable Assent Corporation. 

# Our structure will look something like this

Public SAC1 Coin:
[Mobile Wallet (end user)] <==> [API Server (web hooks/html <==> Infura API<==> ethereum client)] <==> [Ethereum Network (solidity smart-contract)]

Private SAC2 Token:

[Mobile Wallet (end user)] <==> [API Server (web3 <==> SAC API<==> web hooks/html)]<==> [Private Ethereum Network (Token Ambassador Nodes) <= = > (web application/javascript)<==>solidity code<==> ethereum client)] <==> [ Master Node (web application/javascript)<==>(ethereum client) ]



## Getting Started

This application currently operates using our api you can see and test on postman here: [SAC-ERC20Token-API](https://documenter.getpostman.com/view/4404312/SW14Uwww?version=latest)

The API communicates with our Smart Contract:
PRESENT PUBLIC SMART CONTRACT:
Token Contract: 0x3e27A81e83567aD1A24ae67dEec3dAda8ce2c3ec on www.etherscan.io

-------------------------------------------------------------------------
The software development team will have private access to this github project workspace. The most stable version of the code is on the Master branch. Each team member will have access to the codebase on the github cloud. Each developer will be assigned their own branch and must create a github workspace directory on their own local devices.

Please download github desktop here: [Github Desktop](https://desktop.github.com/). 

Once downloaded a github folder directory will automatically be created. You will be sent a link to the repository you are assigned to based on your skill set.

New code is first created on personal team member workspaces then committed to his or her assigned github repository. Team members should notify the team when an update has been committed through the [Trello Board: Coding Workflow](https://trello.com/b/AQStNHQh/coding-workflow), or the [slack group](https://join.slack.com/t/sableassentco-utk2422/shared_invite/zt-d6ih1e9g-czWC8T7C76Rj8ykMzffyEw) (please request an invite from admin if this slack link is no longer valid). 

Admins will then test new code and merge stable changes to the master branch once approved. Every developer is responsible for keeping a daily log of tasks and submitting that report to the project lead (Guillermo or Kiel) during Thursday night sprints. Administrative team meetings will be conducted weekly, every Friday and Monday at 10am, or as needed, or upon request by the CEO; we currentyl use a google hangout group for these meetings. 

For a guide on how to get your local Ethereum development environment up and running click here: [Ethereum Dev Tutorial](https://drive.google.com/open?id=12XUnUY4FmL74sxisb02egOv7_VSovxpGCVXhXZ4QJ_A).

All coding tasks will be distributed on the [Trello Board:IT Admin Notes](https://trello.com/b/YK0grp6n/it-admin-notes). Always check there first for any assigned coding tasks under the “To Do” list.

Please contact one of your software team Lead developers with any and all questions and concerns regarding the assigned tasks. 


Team Lead: Guillermo Perry
Server Administrator, Database Administrator, Enterprise Architect
Phone: 305-791-7491
Email: guillermo@sableassent.com

Co-Lead: Kiel Mansa
Solidity Specialist, WebSite Administrator, Tech Support Manager
Phone: 470-543-2860
Email: kiel@sableassent.com

Team Reporting Schedule:
Daily task logs are submitted to lead every Thursday.
Admin meetings and updates are held on Fridays, & Mondays.
New tasks, updates, and assisted coding is executed by leads on Tuesdays.
Monthly reviews of all team members are done by corporate officers.


A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
