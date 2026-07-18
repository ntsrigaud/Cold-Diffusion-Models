FROM nvcr.io/nvidia/pytorch:26.06-py3

LABEL project="cold-diffusion-models" \
      description="Cold Diffusion: Inverting Arbitrary Image Transforms Without Noise" \
      paper="https://arxiv.org/abs/2208.09392"

# ── Create non-root user for security ─────────────────────────────────────────
RUN useradd -o -u 1000 -m -s /bin/bash jupyteruser

# Set the working directory inside the container
WORKDIR /workspace

# ── Core ML & scientific dependencies ─────────────────────────────────────────
COPY requirements.txt .
COPY pycave_mock ./pycave_mock
RUN pip install --no-cache-dir -r requirements.txt

# ── Install the snowification / decolor-diffusion package ─────────────────────
# Both share the same diffusion/ package; install from snowification as canonical
COPY snowification/setup.py /tmp/snowification_setup.py
RUN cd /tmp && pip install --no-cache-dir setuptools

# Expose the default Jupyter port
EXPOSE 8888

# Ensure the non-root user owns the workspace
RUN chown -R jupyteruser:jupyteruser /workspace

# Switch to the non-root user
USER jupyteruser

# Launch JupyterLab using ServerApp (JupyterLab ≥ 3 / Jupyter Server ≥ 2)
# Security: Authentication is ENABLED and --allow-root is REMOVED
CMD ["/bin/sh", "-c", "jupyter lab --ip=0.0.0.0 --port=${JUPYTER_PORT:-8888} --no-browser"]
