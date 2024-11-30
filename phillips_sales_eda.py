
import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Streamlit app title
st.title("Phillips Sales EDA")

# File upload for Excel files
uploaded_files = st.file_uploader("Upload your Excel files", type=["xlsx"], accept_multiple_files=True)

if uploaded_files:
    # Read and merge uploaded files
    dataframes = []
    for uploaded_file in uploaded_files:
        df = pd.read_excel(uploaded_file)
        dataframes.append(df)

    # Combine all uploaded dataframes into one
    data = pd.concat(dataframes, ignore_index=True)
    st.write("Combined Data Preview:", data.head())

    # Display summary statistics
    st.write("Data Summary:")
    st.write(data.describe())

    # Check for missing values
    st.write("Missing Values Heatmap:")
    fig, ax = plt.subplots(figsize=(10, 6))
    sns.heatmap(data.isnull(), cbar=False, cmap="viridis", ax=ax)
    st.pyplot(fig)

    # Correlation heatmap
    st.write("Correlation Heatmap:")
    fig, ax = plt.subplots(figsize=(10, 6))
    numeric_data = data.select_dtypes(include=["number"])
    if numeric_data.empty:
        st.warning("No numeric columns available for correlation analysis.")
    else:
        sns.heatmap(numeric_data.corr(), annot=True, cmap="coolwarm", ax=ax)
    st.pyplot(fig)

    # Example visualization: Sales trends over time (if date column exists)
    if "Date" in data.columns:
        data["Date"] = pd.to_datetime(data["Date"])
        sales_over_time = data.groupby(data["Date"].dt.to_period("M")).sum()
        st.write("Sales Trends Over Time:")
        fig, ax = plt.subplots(figsize=(10, 6))
        sales_over_time.plot(kind="line", ax=ax)
        st.pyplot(fig)
else:
    st.write("Please upload Excel files to analyze.")
