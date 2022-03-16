#!/usr/bin/env python
# coding: utf-8

# In[1]:


#Import libraries

import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import matplotlib
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8) #Adjusts the configuration of the plots we will create

# Read in the data

df = pd.read_csv(r'C:\Users\TanakaNigel\Desktop\Data Analysis Project\SQL Data Exploration - Project 1 of 4\movies.csv')


# In[2]:


#Looking at data

df.head()


# In[3]:


#Check for missing data

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, pct_missing))


# In[4]:


# Data types present

df.dtypes


# In[5]:


#Replacing NaN with O since latest dataset has missing data in some columns
df=df.fillna(0)


# In[6]:


#Change budget and gross column data types

df['budget']=df['budget'].astype('int64')

df['gross']=df['gross'].astype('int64')


# In[7]:


df


# In[8]:


#Create correct year column

df['yearcorrect'] = df['released'].astype(str).str[:4]

df


# In[21]:


#Order data by gross revenue

df=df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[ ]:


# To look at all the data and remove '...'

#pd.set_option('display.max_rows',None)


# In[17]:


#Remove duplicates, however there no duplicates

#df['company'].drop_duplicates().sort_values(ascending=False)


# In[18]:


df


# In[19]:


# Prediction 1: Budget will have high correlation (more money spent = more revenue)


# In[24]:


# Scatter plot with budget vs gross revenue

plt.scatter(x=df['budget'], y=df['gross'])

plt.title('Budget vs Gross Earnings')

plt.xlabel('Gross Earnings')

plt.ylabel('Budget for Film')

plt.show()


# In[22]:


df.head()


# In[31]:


#Regression plot to check to determine if there is an actual correlation
#Plot Budget vs Gross using seaborn

sns.regplot(x='budget', y='gross', data=df, scatter_kws={'color':'red'}, line_kws={'color':'black'})


# In[34]:


# Detetmining what the actual correlation is between Budget and Gross Revenue
# Types of corr. in Python = 'Pearson'(default), 'Kendall','Spearman'

df.corr(method='pearson')


# In[35]:


#Conclusion 1: High Correlation between Budget and Gross


# In[37]:


#Visualizing above correlation matrix

correlation_matrix=df.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matrix for Numeric Features')

plt.xlabel('Movie Features')

plt.ylabel('Movie Features')

plt.show()


# In[38]:


# Prediction 2:Company will have a high correlation (bigger company = more revenue)

# Company is in string format(object type) so it must be converted to intger in order to be used (numerized)

df_numerized = df

for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name] = df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes
        
df_numerized


# In[39]:


correlation_matrix=df_numerized.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matrix for Numeric Features')

plt.xlabel('Movie Features')

plt.ylabel('Movie Features')

plt.show()


# In[40]:


#Original matrix

df_numerized.corr()


# In[42]:


# Reorginize to see highest correlations, using unstacking

correlation_mat = df_numerized.corr()

corr_pairs = correlation_mat.unstack()

corr_pairs


# In[43]:


# Pair up correlations

sorted_pairs = corr_pairs.sort_values()

sorted_pairs


# In[44]:


high_corr = sorted_pairs[(sorted_pairs)>0.5]

high_corr


# In[ ]:


# Conclusion 2: Votes and Budget have the highest correlation to gross earnings. Company has n correlation

