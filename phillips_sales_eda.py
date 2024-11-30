import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

# Ensure the static folder exists
os.makedirs("static", exist_ok=True)

# Simulate example data (replace with actual dataset)
np.random.seed(42)
data = pd.DataFrame({
    "Date": pd.date_range(start="2018-01-01", periods=100, freq="M"),
    "Sales": np.random.randint(1000, 5000, 100),
    "Profit": np.random.uniform(200, 1000, 100),
    "Discount": np.random.uniform(0, 0.5, 100),
    "Product": np.random.choice(["A", "B", "C", "D", "E"], size=100)
})

print("Data preparation complete.")

# --- Visualization 1: Correlation Heatmap ---
numeric_data = data.select_dtypes(include=["number"])
fig, ax = plt.subplots(figsize=(10, 6))
sns.heatmap(numeric_data.corr(), annot=True, cmap="coolwarm", ax=ax)
plt.title("Correlation Heatmap")
fig.savefig("static/correlation_heatmap.png")
plt.close(fig)

# --- Visualization 2: Missing Values Heatmap ---
fig, ax = plt.subplots(figsize=(10, 6))
sns.heatmap(data.isnull(), cbar=False, cmap="viridis", ax=ax)
plt.title("Missing Values Heatmap")
fig.savefig("static/missing_values_heatmap.png")
plt.close(fig)

# --- Visualization 3: Sales Trends Over Time ---
data["Date"] = pd.to_datetime(data["Date"])
sales_over_time = data.set_index("Date").resample("M").sum(numeric_only=True)
fig, ax = plt.subplots(figsize=(10, 6))
sales_over_time["Sales"].plot(kind="line", ax=ax, marker="o", color="blue")
ax.set_title("Sales Trends Over Time")
ax.set_xlabel("Month")
ax.set_ylabel("Sales")
fig.savefig("static/sales_trends.png")
plt.close(fig)

# --- Visualization 4: Top Products Bar Chart ---
fig, ax = plt.subplots(figsize=(10, 6))
data.groupby("Product")["Sales"].sum().sort_values(ascending=False).head(10).plot(kind="bar", ax=ax, color="orange")
ax.set_title("Top 10 Products by Sales")
fig.savefig("static/top_products.png")
plt.close(fig)

# --- Visualization 5: Profit vs. Discount Scatter Plot ---
fig, ax = plt.subplots(figsize=(10, 6))
sns.scatterplot(data=data, x="Discount", y="Profit", hue="Product", palette="Set2", ax=ax)
ax.set_title("Profit vs. Discount")
fig.savefig("static/profit_vs_discount.png")
plt.close(fig)

# --- Visualization 6: Sales Distribution Histogram ---
fig, ax = plt.subplots(figsize=(10, 6))
sns.histplot(data["Sales"], bins=20, kde=True, color="green", ax=ax)
ax.set_title("Sales Distribution")
fig.savefig("static/sales_distribution.png")
plt.close(fig)

# --- Visualization 7: Sales by Month Area Chart ---
monthly_sales = sales_over_time["Sales"]
fig, ax = plt.subplots(figsize=(10, 6))
monthly_sales.plot(kind="area", ax=ax, color="skyblue", alpha=0.5)
ax.set_title("Sales by Month")
ax.set_xlabel("Month")
ax.set_ylabel("Sales")
fig.savefig("static/sales_by_month.png")
plt.close(fig)

print("All visualizations have been saved in the 'static' folder.")
