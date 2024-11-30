import streamlit as st
import os

# Page Title
st.set_page_config(page_title="EDA Visualizations", layout="wide")
st.title("EDA Visualizations")

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

# Mapping visualizations to file paths
visualizations = {
    "Correlation Heatmap": "static/correlation_heatmap.png",
    "Missing Values Heatmap": "static/missing_values_heatmap.png",
    "Sales Trends Over Time": "static/sales_trends.png",
    "Top 10 Products by Sales": "static/top_products.png",
    "Profit vs. Discount Scatter Plot": "static/profit_vs_discount.png",
    "Sales Distribution Histogram": "static/sales_distribution.png",
    "Sales by Month Area Chart": "static/sales_by_month.png",
}

# Display the selected visualization
st.subheader(visualization)
img_path = visualizations.get(visualization, None)
if img_path and os.path.exists(img_path):
    st.image(img_path, use_column_width=True)
else:
    st.error("Visualization not found. Please run the image generation script.")