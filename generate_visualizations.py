import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

# Ensure the static folder exists
os.makedirs("static", exist_ok=True)

# Simulating example data for visualizations (replace with actual dataset)
np.random.seed(42)
data = pd.DataFrame({
    "Date": pd.date_range(start="2018-01-01", periods=100, freq="M"),
    "Sales": np.random.randint(1000, 5000, 100),
    "Profit": np.random.uniform(200, 1000, 100),
    "Discount": np.random.uniform(0, 0.5, 100)
})

print("Data preparation complete.")

# --- Visualization 1: Correlation Heatmap ---
numeric_data = data.select_dtypes(include=["number"])
fig, ax = plt.subplots(figsize=(10, 6))
sns.heatmap(numeric_data.corr(), annot=True, cmap="coolwarm", ax=ax)
plt.title("Correlation Heatmap")
fig.savefig("static/correlation_heatmap.png")
print("Saved correlation_heatmap.png")
plt.close(fig)

# --- Visualization 2: Missing Values Heatmap ---
fig, ax = plt.subplots(figsize=(10, 6))
sns.heatmap(data.isnull(), cbar=False, cmap="viridis", ax=ax)
plt.title("Missing Values Heatmap")
fig.savefig("static/missing_values_heatmap.png")
print("Saved missing_values_heatmap.png")
plt.close(fig)

# --- Visualization 3: Sales Trends Over Time ---
# --- Visualization 3: Sales Trends Over Time ---
if "Date" in data.columns:
    data["Date"] = pd.to_datetime(data["Date"])  # Ensure Date is in datetime format
    # Group by monthly periods and sum numeric values only
    sales_over_time = data.set_index("Date").resample("M").sum(numeric_only=True)
    
    fig, ax = plt.subplots(figsize=(10, 6))
    sales_over_time["Sales"].plot(kind="line", ax=ax, marker="o", color="blue")
    ax.set_title("Sales Trends Over Time")
    ax.set_xlabel("Month")
    ax.set_ylabel("Sales")
    fig.savefig("static/sales_trends.png")
    print("Saved sales_trends.png")
    plt.close(fig)
else:
    print("No Date column found; skipping sales trends visualization.")
