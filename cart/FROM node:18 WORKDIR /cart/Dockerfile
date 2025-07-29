FROM node:18
WORKDIR /app
COPY . .
EXPOSE 3004
CMD ["node", "-e", "require('http').createServer((_,res)=>res.end('Cart Service Running')).listen(3004)"]
