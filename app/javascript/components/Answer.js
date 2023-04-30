import React, { useState, useEffect, useRef, useCallback } from 'react';

export const Answer = ({ answer, displayText, currentIndex, handleAskAnother, loading, handleLucky }) => {
  if (answer) {
    return (
      <>
        <p>
          <strong>Answer:</strong> <span id="answer">{displayText}</span>
        </p>
        {currentIndex >= answer.length && (
          <button style={{ marginTop: 0 }} onClick={handleAskAnother}>
            Ask another question
          </button>
        )}
      </>
    );
  }

  return (
    <div className="buttons">
      <button type="submit" disabled={loading}>
        {loading ? 'Asking...' : 'Ask question'}
      </button>
      <button className="secondary" onClick={handleLucky}>
        I'm feeling lucky
      </button>
    </div>
  );
};
