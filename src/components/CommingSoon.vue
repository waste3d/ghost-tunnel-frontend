<template>
    <div class="waitlist-container">
      <h1 class="title">{{ title }}</h1>
      <p class="subtitle">{{ subtitle }}</p>
    </div>
  </template>
  
  <script setup>
  defineProps({
    title: String,
    subtitle: String,
  });
  </script>
  
  <style scoped>        
  .waitlist-container {
    font-family: var(--font-family, 'Jura', sans-serif); 
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
    padding: 2rem;
    max-width: 800px;
    margin: auto;
  }
  .title {
    font-size: 3.75rem;
    font-weight: 700;
    letter-spacing: 0em;
    color: #ffffff;
    margin: 0;
    line-height: 1.1; 
  }
  .subtitle {
    color: #a1a1aa; 
    font-size: 1.25rem;
    margin-top: 1.5rem;
    max-width: 580px;
    line-height: 1.6;
    font-weight: 400;
  }
  @media (max-width: 640px) {
    .title {
      font-size: 2.5rem;
    }
    .subtitle {
      font-size: 1.125rem;
    }
  }
  </style>