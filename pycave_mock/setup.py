from setuptools import setup, find_packages

setup(
    name="pycave",
    version="1.0.0",
    description="Mock pycave using scikit-learn for compatibility",
    packages=find_packages(),
    install_packages=["scikit-learn", "numpy", "torch"]
)
