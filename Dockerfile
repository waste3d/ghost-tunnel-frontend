FROM node:20-alpine as builder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build
        

FROM node:20-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install
        
COPY --from=builder /app/dist ./dist/

EXPOSE 4321

CMD ["npm", "run", "preview"]
