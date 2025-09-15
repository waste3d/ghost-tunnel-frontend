# --- ЭТАП 1: Установка зависимостей ---
    FROM node:20-alpine AS deps
    WORKDIR /app
    COPY package*.json ./
    RUN npm install
    
    # --- ЭТАП 2: Сборка проекта ---
    FROM node:20-alpine AS builder
    WORKDIR /app
    COPY --from=deps /app/node_modules ./node_modules
    COPY . .
    RUN npm run build
    
    # --- ЭТАП 3: Финальный образ ---
    FROM node:20-alpine AS runner
    WORKDIR /app
    
    # Установка зависимостей, необходимых для запуска preview
    COPY package*.json ./
    RUN npm install --omit=dev
    
    # ▼▼▼ ГЛАВНОЕ ИЗМЕНЕНИЕ ▼▼▼
    # Копируем ИСХОДНЫЙ КОД, который нужен astro preview для построения маршрутов
    COPY --from=builder /app/src ./src
    
    # Копируем остальные файлы, необходимые для запуска
    COPY --from=builder /app/dist ./dist
    COPY --from=builder /app/public ./public
    COPY --from=builder /app/astro.config.mjs ./
    COPY --from=builder /app/package.json ./
    COPY --from=builder /app/tsconfig.json ./
    
    EXPOSE 4321
    CMD ["npm", "run", "preview"]