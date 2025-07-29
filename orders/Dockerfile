FROM node:18
WORKDIR /app
COPY . .
EXPOSE 3003
CMD ["node", "-e", "require('http').createServer((_,res)=>res.end('Orders Service Running')).listen(3003)"]
