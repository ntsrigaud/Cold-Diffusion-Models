import torch
from sklearn.mixture import GaussianMixture as SklearnGaussianMixture

class GaussianMixture:
    def __init__(self, num_components=1, covariance_type='full', convergence_tolerance=1e-3, *args, **kwargs):
        self.model = SklearnGaussianMixture(
            n_components=num_components,
            covariance_type=covariance_type,
            tol=convergence_tolerance,
            random_state=42
        )
        self.num_components = num_components

    def fit(self, X):
        if torch.is_tensor(X):
            X_np = X.detach().cpu().numpy()
        else:
            X_np = X
        self.model.fit(X_np)
        return self

    def sample(self, num_datapoints=1):
        samples, _ = self.model.sample(n_samples=num_datapoints)
        return torch.tensor(samples, dtype=torch.float32)

    def get_params(self, deep=True):
        return self.model.get_params(deep=deep)

    def __repr__(self):
        return f"MockGaussianMixture(num_components={self.num_components})"
