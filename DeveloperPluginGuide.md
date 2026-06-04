# Using Developer Plugins

## What are Developer Plugins?
Developer plugins are a special type of plugin that comes pre-installed with Tasker and is often used for development purposes. They are not meant to be used by end-users and are typically used for testing debugging and developing consumer plugins. 

## Why use Developer Plugins?
In Tasker current state, only developer plugins can be loaded and fully used. So if you want to test out Tasker's features, you will need to use the build-in plugins we provide.

## How to enable Developer Plugins?
Opening Tasker for the first time, developer plugins will not be available. To enable them: 
1) Go to settings (<code>⌘,</code> or press the gear icon on the bottom left of the window), navigate to the **Developer** category and enable developer tools.
2) Restart Tasker
3) Once restarted go to the plugins tab (<code>⌘P</code> or press the puzzle icon on the bottom left of the window). 
4) At the top center of the window you should see a control with two menus "Explore" and "Installed". Click on "Installed" (or use <code>⌘2</code>) and you should see a list of plugins. The ones with the "Developer" tag (<img width="25" height="25" alt="Developer" src="https://github.com/user-attachments/assets/5f16d1b9-7ba0-4ac4-a27b-4919861e90da" />
) are developer plugins. You can click the toggle on the right side of each plugin to enable or disable them.

## What developer plugins are available?
Currently, we have the following developer plugins available:
- **Console**: A plugins that shows all logs, warnings and errors that Tasker produces. Use it to get an idea of how Tasker works.
- **API Test**: A selection of various actions, that allow you to trigger and test various features of Tasker such as creating an event or pushing a notification. Use it to test out Tasker's features and see how they work.
