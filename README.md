# gemini-config

## Getting Started

```bash
git clone https://github.com/cornellsh/gemini-config.git
cd gemini-config
./scripts/setup.sh
```

## What's in here?

**Browser Control (`/browser:*`)**  
I use this to spin up headless Chrome. It's helpful when I need to verify that a UI actually works instead of just guessing.

**The Humanizer**  
This is a skill to strip out all the "pivotal moments" and "digital landscapes" that AI loves to hallucinate.

## How I use it

If I need to check a site, I just run:  
`gemini /browser:start`

If a piece of writing feels "off" or too robotic, I'll tell Gemini:  
"Run the humanizer on this."

## The Structure

- `user-config/skills/`: Where I keep the logic for things like the humanizer.
- `user-config/commands/`: Shortcuts for the CLI.
- `user-config/GEMINI.md`: The "master" instructions for how I want the CLI to behave.
- `scripts/`: Mostly just the setup and browser launch scripts.
