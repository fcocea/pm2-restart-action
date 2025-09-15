Simple way to restart a service on a remote server using PM2 for pnpm projects.

The logic is simple:
- Connect to the server using SSH
- Go to the project folder
- Pull the last changes
- Restart the service

### Example
```yml
name: Deploy last changes
on:
  push:
    branches:
      - main
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Restart service
        uses: fcocea/pm2-restart-action@v1.0
        with:
          SSH_HOST: ${{ secrets.SSH_HOST }}
          SSH_USER: ${{ secrets.SSH_USER }}
          SSH_PASS: ${{ secrets.SSH_PASSWORD }}
          SSH_PORT: ${{ secrets.SSH_PORT }} # Default: 22
          FOLDER: ${{secrets.FOLDER}}
          PM2_SERVICE: ${{secrets.PM2_SERVICE}}
          REPO_BRANCH: main # Default: main    
```


### TODO
- [ ] Add support for SSH keys
- [ ] Add support for other package managers
- [ ] Add support for other services
