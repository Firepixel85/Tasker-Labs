<div align="center">
<img width="596" height="181" alt="Banner Github" src="https://github.com/user-attachments/assets/f7cae6ed-1e71-41b1-b42f-da7d257ea2a9" />

</div>
<br>
	
<a href="https://github.com/Rosepen-Studios/Rose-Garden">![Stamp](https://github.com/user-attachments/assets/7c004551-b9ce-452f-9284-2fce97f640f3)

<h2 align="left">Productivity like never before!</h2>

### Introduction
Tasker 2.0 is a productivity powerhouse, designed to be fully plugin driven, allowing you to customize and extend its functionality to suit your unique workflow. Choose the features that suit you best and ignore the rest, making Tasker your own personal productivity dashboard.

### A message to HackClub reviewers
Tasker 2.0 is currently in beta. All planned features are implemented. I am currently in the process of creating plugins for Tasker, as without plugins it doesn't do much **useful** stuff. The first of those plugins is available for you to test now. It is a time/focus tracker that uses project and goals to keep you organized. You can view the plugin's repo [here](https://github.com/Rosepen-Studios/Focus) or follow the installation instructions I provide in the [latest release](https://github.com/Firepixel85/tasker-labs/releases/latest). Last time this project was rejected for the following reason: <code>hi! while i was testing your app. the core plugins didn't seem to actually do anything. while we acknowledge that it's a wip project, we expect core plugins to work as it's shipped for over 100 hours.</code> This issue has been addressed by creating an external plugin you can actually use in your daily life, so you can imagine how Tasker will work when more plugins are available. The plugin in question is the Focus plugin mentioned above.

### About running the app from source
You will need a device running MacOS 11.00+ and Godot 4.6 stable. After downloading and importing the source code to Godot running the project shouldn't produce any fatal errors, that being said any errors through that force the engine to break should be resolved by hitting <code>F12</code>. Note that due to security reasons you want be able to use GitHub OAuth with any version of Tasker not exported by me, as the secrets required for the OAuth are not tracked by Git for obvious security reasons. Commit [18c0e5d](https://github.com/Firepixel85/Tasker-Labs/commit/18c0e5dabeb4a203a0d1a07b0552ecc3a15e1b29) adds a fix that allows the app to run event if the GitHub OAuth secrets are missing. Please note that source is ahead of the current release and has new untested features like the DataView plugin.

### Installation
Tasker 2.0 is currently in late development with a running beta. You can now go to our [releases page](https://github.com/Firepixel85/Tasker-Labs/releases) and grab the latest beta build to try for yourself. Please note that these builds are not fully tested and may contain minor bugs. Feel free to [report](https://github.com/Firepixel85/Tasker-Labs/issues) any bugs you find. Please note that for now Tasker is exclusively available on Apple Silicon powered devices running MacOS 11.00+. To install the latest build:
1) Go to the [latest release](https://github.com/Firepixel85/Tasker-Labs/releases/latest)
2) Download the <code>Tasker.dmg</code> file from the assets
3) Open the <code>.dmg</code> file you downloaded and drag Tasker into the Applications folder as the arrow indicates
4) Run Tasker

If the app is blocked by Gatekeeper:

1) Open System Settings
2) Go to Privacy & Security
3) Scroll down to where Tasker is displayed as blocked
4) Click "Open anyway"
5) Follow the popups clicking "Allow anyway" and authenticating with your Touch-ID/Password

### Documentation
As Tasker is still in development, we have not yet created comprehensive documentation. However, we are actively working on it and plan to have it available soon.

### Tasker for developers
Tasker is built with developers in mind, and we want to make it as easy as possible for you to contribute and create plugins. We are currently working on creating the needed documentation and resources to help you get started with plugin development. Rest assured, on release, Tasker 2.0 will be a developer-friendly platform with plenty of resources and an easy to use plugin API to help you create the amazing plugins that power Tasker.

### Screenshots
<img width="1248" height="870" alt="Screenshot 2026-07-30 at 9 56 35 PM" src="https://github.com/user-attachments/assets/0d72c042-3528-4eb3-9143-8905b95366ee" />
<img width="1248" height="870" alt="Screenshot 2026-07-30 at 9 57 19 PM" src="https://github.com/user-attachments/assets/a30265a5-04c5-4037-b1b9-62115d49b9ae" />
<img width="1248" height="870" alt="Screenshot 2026-07-30 at 10 00 02 PM" src="https://github.com/user-attachments/assets/30c31216-9692-4bd1-a5db-1ddaf0c826e1" />

### Development Story
During development it became apparent that I needed to create Tasker's systems to be as extensible as possible, which was quite different then what I was used to. It meant creating a whole new UI library that allowed for the creation of consistent, customizable, accessible & most importantly: good looking UI. Also I needed to figure out how to split the app into multiple independent systems that could work in isolation or together, making sure Tasker is resilient to error states. But the hardest part was designing all those systems to also be usable, by someone who doesn't know how Tasker works I.E. the plugins developers, so every API needed to be simple, easy-to-use, powerful & error resistant, while also being able to function in different environments (in-engine, developer plugin, exported plugin, etc.)

### Tech Stack
Tasker is built in Godot 4.6 and is currently only targeting apple silicon. The following tools and plugins were used in development:

| Tool | Author  | Use | 
| ---- | ------- | ------- |
| Godot | Juan Linietsky & Contributors | Main engine |
| Rose Garden | _M2x (Me) | UI Library |
| Zed | Zed Industries & Contributors | Script Editing |
| Lucid Icons | Eric Fennis & Contributors | Icon Library |
| Figma | The Figma Team | UI Design |
| Linear | The Linear Team | Organization |

### License
We use a custom license for Tasker called FUL (Free Use License), which you can view [here](https://github.com/Firepixel85/Tasker-Labs/blob/main/LICENSE.md). This license gives you the freedom to use, modify, and distribute Tasker as you see fit, while also ensuring that our code may never be used to generate cash profit for anyone. We believe in the power of open-source software and want to make sure that Tasker remains free and accessible to everyone.

### A statement on AI
No generative AI was used to create textures, code or any other assets for the app. HOWEVER, AI has been used during development, clearly for advisory purposes, such as helping design the app's architecture, generating code snippets, and general advice. We want to be transparent about our use of AI and ensure that our users understand the extent of its involvement in the development process. Tasker has been fully developed by human creativity, assisted/accelerated by AI.

<br>
<div align="center">

[License](https://github.com/Firepixel85/Tasker-Labs/blob/main/LICENSE.md) | [Terms of Use](https://github.com/Firepixel85/Tasker-Labs/blob/main/Terms%20of%20Use.md) | [Privacy Policy](https://github.com/Firepixel85/Tasker-Labs/blob/main/Privacy%20Policy.md)

<br>
<div align="center">

Developed by Rosepen Studios
</div>
