import React, { useState, useEffect, useRef, useCallback } from 'react';
import { randomInteger, getCachedQuestion } from '../utils';
import { Answer } from './Answer';

const defaultQna = {
  question: 'What is The Minimalist Entrepreneur about?',
  answer: '',
  audio_url: ''
};

export const Main = () => {
  const cachedQuestion = getCachedQuestion() ?? defaultQna;
  const [qna, setQna] = useState(cachedQuestion);
  const [displayText, setDisplayText] = useState(cachedQuestion.answer);
  const [currentIndex, setCurrentIndex] = useState(displayText.length);
  const [loading, setLoading] = useState(false);
  const [isAutoFilled, setIsAutoFilled] = useState(false);

  const textAreaRef = useRef();
  const audioRef = useRef();
  const intervalRef = useRef(null);

  const { question, answer } = qna;

  useEffect(() => {
    const randomInterval = randomInteger(30, 70);
    intervalRef.current = setInterval(() => {
      if (currentIndex >= answer.length) {
        clearInterval(intervalRef.current);
        if (qna.id) {
          history.pushState({}, null, '/question/' + qna.id);
        }
        return;
      }
      setDisplayText(prevText => prevText + answer[currentIndex]);
      setCurrentIndex(currentIndex + 1);
    }, randomInterval);

    return () => {
      clearInterval(intervalRef.current);
    };
  }, [currentIndex, answer, qna.id]);

  useEffect(() => {
    if (isAutoFilled) {
      triggerAsk();
    }
  }, [question, isAutoFilled]);

  const triggerAsk = async () => {
    setLoading(true);
    try {
      const csrfToken = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute('content');

      const res = await fetch('/ask', {
        method: 'post',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify({ question })
      });
      const data = await res.json();
      setLoading(false);
      setQna({ ...data });
    } catch (error) {
      setLoading(false);
      console.error('Error fetching answer:', error);
    }
  };

  const handleSubmit = async e => {
    e.preventDefault();
    if (!question) {
      alert('Please ask a question!');
      return;
    }
    triggerAsk();
  };

  const reset = useCallback(() => {
    setDisplayText('');
    setCurrentIndex(0);
    setLoading(false);
    audioRef.current?.pause();
  }, [setDisplayText, setCurrentIndex, setLoading, audioRef]);

  const handleQuestionChange = useCallback(e => {
    setQna({ ...defaultQna, question: e.target.value });
    setIsAutoFilled(false);
    reset();
  }, [setQna, setIsAutoFilled, reset]);

  const handleLucky = useCallback(e => {
    e.preventDefault();

    const sampleQs = [
      'What is a minimalist entrepreneur?',
      'What is your definition of community?',
      'How do I decide what kind of business I should start?'
    ];
    const random = ~~(Math.random() * sampleQs.length);
    setQna({
      ...defaultQna,
      question: sampleQs[random]
    });
    setIsAutoFilled(true);
    reset();
  }, [setIsAutoFilled, reset, setQna]);

  const handleAskAnother = useCallback(e => {
    e.preventDefault();
    setQna({ ...defaultQna, question });
    textAreaRef.current?.select();
    reset();
  }, [defaultQna, question, reset, textAreaRef, setQna]);

  return (
    <div>
      <form onSubmit={handleSubmit}>
        <textarea
          ref={textAreaRef}
          value={question}
          onChange={handleQuestionChange}
        />
        <Answer
          answer={answer}
          displayText={displayText}
          currentIndex={currentIndex}
          handleAskAnother={handleAskAnother}
          loading={loading}
          handleLucky={handleLucky}
        />
      </form>

      <audio
        volume={0.1}
        controls
        autoPlay
        src={qna.audio_url}
        type="audio/mp3"
      />
    </div>
  );
};
