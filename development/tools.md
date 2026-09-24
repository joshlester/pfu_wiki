
# Tools

## Babel

Output directory
```
npx babel --config-file ./babel.config.json src/server -d dist/server --extensions .ts,.tsx
```
Output file
```
npx babel --config-file ./babel.config.json src/file.tsx -o dist/file.js --extensions .ts,.tsx
```