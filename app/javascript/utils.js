export function getCachedQuestion() {
  const questionDiv = document.querySelector('[data-id="serialized-question"]');
  const questionString = questionDiv?.dataset?.content?.replace(/\\"/g, '"');

  if (questionString && questionString !== 'null') {
    const r = JSON.parse(questionString);
    return {
      ...r
    };
  }
  return null;
}

export function randomInteger(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}
