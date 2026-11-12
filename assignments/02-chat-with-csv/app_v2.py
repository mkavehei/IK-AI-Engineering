# app_v2.py - a simple practice app to learn the structure of a Streamlit app.
# No AI and no API key here. Run it with:  streamlit run app_v2.py

# 1. Imports: load the add-ons
import streamlit as st
import pandas as pd

# 2. Page setup: tab title, icon and heading
st.set_page_config(page_title="My First App", page_icon="📊")
st.title("📊 My File Viewer")
st.write("Upload a CSV or a text file and see what is inside.")

# 3. Sidebar: the left panel for settings
with st.sidebar:
    st.header("Settings")
    name = st.text_input("Your name")
    rows_to_show = st.slider("Rows to show (CSV only)", 1, 20, 5)

# 4. Main inputs: the upload button
file = st.file_uploader("Upload a file", type=["csv", "txt"])

# 5. Do the work, and 6. show the result
if file is None:
    st.info("Please upload a CSV or a .txt file.")

elif file.name.lower().endswith(".csv"):
    # A table: pandas reads it
    df = pd.read_csv(file)
    st.success(f"Hello {name or 'there'}! Your table has {len(df)} rows and {len(df.columns)} columns.")
    st.write("Column names:", ", ".join(df.columns))
    st.dataframe(df.head(rows_to_show))

else:
    # Plain text: read it as normal text
    text = file.read().decode("utf-8", errors="replace")
    st.success(f"Hello {name or 'there'}! Your text has {len(text.split())} words.")
    st.text(text[:2000])  # show the first 2,000 characters
