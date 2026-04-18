FROM docker.io/searxng/searxng:latest

USER root
COPY --chown=977:977 sxng_locales.py /usr/local/searxng/searx/sxng_locales.py
RUN find /usr/local/searxng/searx/__pycache__ -name 'sxng_locales*.pyc' -delete && \
    /usr/local/searxng/.venv/bin/python -m compileall -q \
        --invalidation-mode=unchecked-hash \
        /usr/local/searxng/searx/sxng_locales.py && \
    chown -R 977:977 /usr/local/searxng/searx/__pycache__
USER searxng
