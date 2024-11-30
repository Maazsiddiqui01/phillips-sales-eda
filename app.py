import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

# Page Title
st.set_page_config(page_title="EDA Visualizations", layout="wide")
st.title("EDA Visualizations")

# Simulate example data (replace with your actual dataset)
np.random.seed(42)
data = pd.DataFrame({
    "Date": pd.date_range(start="2018-01-01", periods=100, freq="M"),
    "Sales": np.random.randint(1000, 5000, 100),
    "Profit": np.random.uniform(200, 1000, 100),
    "Discount": np.random.uniform(0, 0.5, 100),
    "Product": np.random.choice(["A", "B", "C", "D", "E"], size=100)
})

# Sidebar for Navigation
visualization = st.sidebar.selectbox(
    "Select a Visualization",
    [
        "Correlation Heatmap",
        "Missing Values Heatmap",
        "Sales Trends Over Time",
        "Top 10 Products by Sales",
        "Profit vs. Discount Scatter Plot",
        "Sales Distribution Histogram",
        "Sales by Month Area Chart"
    ]
)

# Generate visualizations dynamically
if visualization == "Correlation Heatmap":
    numeric_data = data.select_dtypes(include=["number"])
    fig, ax = plt.subplots(figsize=(10, 6))
    sns.heatmap(numeric_data.corr(), annot=True, cmap="coolwarm", ax=ax)
    st.pyplot(fig)

elif visualization == "Missing Values Heatmap":
    fig, ax = plt.subplots(figsize=(10, 6))
    sns.heatmap(data.isnull(), cbar=False, cmap="viridis", ax=ax)
    st.pyplot(fig)

elif visualization == "Sales Trends Over Time":
    data["Date"] = pd.to_datetime(data["Date"])
    sales_over_time = data.set_index("Date").resample("M").sum(numeric_only=True)
    fig, ax = plt.subplots(figsize=(10, 6))
    sales_over_time["Sales"].plot(kind="line", ax=ax, marker="o", color="blue")
    ax.set_title("Sales Trends Over Time")
    ax.set_xlabel("Month")
    ax.set_ylabel("Sales")
    st.pyplot(fig)

elif visualization == "Top 10 Products by Sales":
    fig, ax = plt.subplots(figsize=(10, 6))
    data.groupby("Product")["Sales"].sum().sort_values(ascending=False).head(10).plot(kind="bar", ax=ax, color="orange")
    ax.set_title("Top 10 Products by Sales")
    st.pyplot(fig)

elif visualization == "Profit vs. Discount Scatter Plot":
    fig, ax = plt.subplots(figsize=(10, 6))
    sns.scatterplot(data=data, x="Discount", y="Profit", hue="Product", palette="Set2", ax=ax)
    ax.set_title("Profit vs. Discount")
    st.pyplot(fig)

elif visualization == "Sales Distribution Histogram":
    fig, ax = plt.subplots(figsize=(10, 6))
    sns.histplot(data["Sales"], bins=20, kde=True, color="green", ax=ax)
    ax.set_title("Sales Distribution")
    st.pyplot(fig)

elif visualization == "Sales by Month Area Chart":
    sales_over_time = data.set_index("Date").resample("M").sum(numeric_only=True)
    monthly_sales = sales_over_time["Sales"]
    fig, ax = plt.subplots(figsize=(10, 6))
    monthly_sales.plot(kind="area", ax=ax, color="skyblue", alpha=0.5)
    ax.set_title("Sales by Month")
    ax.set_xlabel("Month")
    ax.set_ylabel("Sales")
    st.pyplot(fig)
