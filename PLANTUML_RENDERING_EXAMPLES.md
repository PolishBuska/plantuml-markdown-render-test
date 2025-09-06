# PlantUML Rendering Examples on GitHub

This document shows different ways to display PlantUML diagrams on GitHub.

## Method 1: Code Block (Current - Shows as Text)

```plantuml
@startuml
!include ./diagrams/er-postgres.puml
@enduml
```

**Result**: Shows as plain text code block (what you're seeing now)

## Method 2: PlantUML Server URL

You can use PlantUML's online server to render diagrams by encoding the PlantUML source:

![ER Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/PolishBuska/plantuml-markdown-render-test/main/docs/diagrams/er-postgres.puml)

**Note**: This method fetches your `.puml` file from GitHub and renders it through PlantUML's server.

## Method 3: Pre-rendered Images

Convert PlantUML to images locally and commit them:

1. Install PlantUML locally
2. Generate PNG/SVG files 
3. Reference the generated images

## Method 4: GitHub Actions (Automated)

Set up GitHub Actions to automatically convert PlantUML files to images on push.

## Method 5: Browser Extensions

Use browser extensions like "PlantUML Viewer" to render PlantUML code blocks in your browser.

## Testing Different Diagram Types

### Simple Sequence Diagram
![Sequence](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/PolishBuska/plantuml-markdown-render-test/main/docs/diagrams/sequence-bim-upload.puml)

### Class Diagram  
![Class Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/PolishBuska/plantuml-markdown-render-test/main/docs/diagrams/class-diagram.puml)

### Use Case Diagram
![Use Case](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/PolishBuska/plantuml-markdown-render-test/main/docs/diagrams/usecase-bim.puml)

## Summary

- **Code blocks**: Show as plain text (current behavior)
- **PlantUML server URLs**: Render diagrams dynamically 
- **Pre-rendered images**: Most reliable but requires manual/automated conversion
- **Browser extensions**: Client-side rendering for development

The PlantUML server method (Method 2) should show actual rendered diagrams when viewed on GitHub!
