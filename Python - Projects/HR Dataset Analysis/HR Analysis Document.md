# HR Dataset Analysis with Python

## Project Overview

This project involves an in-depth analysis of an HR employee attrition dataset using Python (Pandas, NumPy, Matplotlib, and Seaborn). The primary objective was to clean and transform the data, conduct exploratory data analysis (EDA), and extract actionable business insights related to employee satisfaction, attrition, and workforce demographics. Advanced data manipulation and visualization techniques were leveraged to answer key HR questions and guide strategic recommendations.

## Key Skills & Tools Used

- Data Cleaning & Transformation: (String manipulation, mapping categorical codes to labels, dropping irrelevant columns)
- Data Analysis: (Pandas DataFrame operations, aggregation, grouping, value counts)
- Data Visualization: (Matplotlib, Seaborn for histograms, bar charts, and heatmaps)
- Analytical Techniques: (Attrition analysis, satisfaction level breakdowns, demographic segmentation, trend analysis)

## Analytical Questions & Key Findings

### 1. Average Age by Department: Understand the average age distribution of employees across different departments.

```python
avg_age_by_department = df.groupby('department')['age'].mean().round().reset_index()
avg_age_by_department
ax = sns.boxplot(data = df,x='department',y='age')
plt.title('Average Age distribution by Department')
plt.xlabel('Department')
plt.ylabel('Avg Age')
plt.tight_layout()
for i,dept in enumerate(avg_age_by_department['department'].sort_values(ascending=False).unique()):
    avg_age = avg_age_by_department[avg_age_by_department['department'] == dept]['age'].values[0]
    ax.text(i,avg_age,f'{avg_age:.1f}')
plt.show()
```

<img width="796" height="590" alt="Screenshot 2025-08-11 225033" src="https://github.com/user-attachments/assets/2c857ffc-c009-4898-a4f0-ec52266aa184" />

*Departments are composed of a healthy blend of fresh talent and seasoned professionals, ensuring dynamic collaboration.*

---

### 2. Attrition Analysis: Identify the count of employees who have left the company versus those who have not.

```python
att_ratio = df['attrition'].value_counts().reset_index()
att_ratio['pct %'] = round(att_ratio['count'] / df['attrition'].count() * 100,2).astype(str) + '%'
att_ratio

plt.pie(
    x=att_ratio['count'],
    labels = att_ratio['attrition'],
    shadow=True,
    autopct='%1.1f%%',
    colors = ["#938A22","#E2D588"]
)
plt.title('Attrition Ratio by Employees Count')
plt.show()
```

<img width="490" height="502" alt="Screenshot 2025-08-11 225129" src="https://github.com/user-attachments/assets/df017ede-cb0d-4af9-8c66-993a6e05801f" />

*The majority of employees demonstrate strong loyalty, with attrition well below critical thresholds.*

---

### 3. Job Role Distribution: Analyze the distribution of employees across various job roles within the organization.

```python
emps_by_job_role = df['jobrole'].value_counts().reset_index()
emps_by_job_role
plt.figure(figsize=(12,5))
ax = sns.barplot(data = emps_by_job_role,x='jobrole',y='count',width=0.3,palette='vanimo_r')
plt.title('Employees Distribution in Organization by Job Role')
plt.xlabel('Job Role')
plt.ylabel('Total Employees')
plt.xticks(rotation = 45,fontsize=9)
plt.ylim(top = emps_by_job_role['count'].max()*1.2)
for i in ax.containers:
    ax.bar_label(i,fontsize=7,label_type='edge',padding=3)
plt.tight_layout()
plt.show()
```

<img width="1482" height="612" alt="Screenshot 2025-08-11 225221" src="https://github.com/user-attachments/assets/22568542-d2c8-47de-8b92-34e064d5fb94" />

*The workforce spans a broad range of roles, supporting organizational agility and innovation.*

---

### 4. Average Monthly Income by Job Role: Determine the average monthly income for each specific job role.

```python
avg_salary_by_jobrole = df.groupby('jobrole')['monthlyincome'].mean().reset_index().round()
avg_salary_by_jobrole
plt.figure(figsize=(12,5))
ax = sns.barplot(data = avg_salary_by_jobrole,x='jobrole',y='monthlyincome',width=0.3,palette='Set1')
plt.title('Average Salary Distribution in Organization by Job Role')
plt.xlabel('Job Role')
plt.ylabel('Avg Salary',fontsize=11)
plt.xticks(rotation = 45,fontsize=9)
plt.ylim(top = avg_salary_by_jobrole['monthlyincome'].max()*1.2)
for i in ax.containers:
    ax.bar_label(i,fontsize=7,label_type='edge',padding=3)
plt.tight_layout()
plt.show()
```

<img width="1486" height="604" alt="Screenshot 2025-08-11 225310" src="https://github.com/user-attachments/assets/bc86ac3d-ee34-4c34-b686-2dbd615f61e0" />

*Salary structures are closely aligned with job responsibilities, rewarding expertise and leadership.*

---

### 5. Overtime Percentage: Calculate the percentage of employees who work overtime.

```python
emps_overtime_counts = df['overtime'].value_counts().reset_index()
emps_overtime_counts['pct %'] = round(emps_overtime_counts['count'] / emps_overtime_counts['count'].sum() * 100,2).astype(str) + '%'
emps_overtime_counts
plt.figure(figsize=(6,6))
plt.pie(
    x=emps_overtime_counts['count'],
    labels = emps_overtime_counts['overtime'],
    shadow=True,
    autopct='%1.1f%%',
    colors = ["#0EA580","#ABE7E4"],
    explode=(0,0.1)
)
plt.title('Overtime Percentage by Employees Count')
plt.show()
```

<img width="606" height="622" alt="Screenshot 2025-08-11 225428" src="https://github.com/user-attachments/assets/eb3dc092-bb38-4272-8cde-ef48d5913527" />

*A significant portion of employees contribute extra hours, highlighting dedication but signaling a need for balance.*

---

### 6. Job Satisfaction by Marital Status: Examine how job satisfaction levels vary based on employees' marital status.

```python
js_by_ms_count = df.groupby(['maritalstatus','jobsatisfaction'])['age'].count().reset_index()
t = js_by_ms_count.pivot_table(index='maritalstatus',columns='jobsatisfaction',values='age',aggfunc='sum')
plt.figure(figsize=(10,5))
sns.heatmap(data=t,annot=True,fmt='d',cmap='copper')
plt.title('Employees vary in this Organization by Job Satisfaction & Martial Status')
plt.xlabel('Martial Status',labelpad=10,fontsize=11)
plt.ylabel('Job Satisfaction',labelpad=10,fontsize=11)
plt.show()
```

<img width="976" height="593" alt="Screenshot 2025-08-11 225513" src="https://github.com/user-attachments/assets/6578d94a-fd92-4d44-9702-02ba7d13f349" />

*Job satisfaction patterns suggest that personal circumstances influence engagement and fulfillment at work.*

---

### 7. Years at Company for Attrition vs. Stayed: Compare the average years of service for employees who have left the company versus those who have remained.

```python
avg_years_by_att_rate = df.groupby('attrition')['yearsatcompany'].mean().reset_index().round(2)
avg_years_by_att_rate
plt.figure(figsize=(5,5))
plt.pie(
    x=avg_years_by_att_rate['yearsatcompany'],
    labels = avg_years_by_att_rate['attrition'],
    shadow=True,
    autopct='%1.1f%%',
    explode=(0,0.05),
    colors=["#6E93EB","#0D79ED"]
)
plt.title('Average years of Employees stayed in this Organization',fontsize=9)
plt.tight_layout()
plt.show()
```

<img width="586" height="608" alt="Screenshot 2025-08-11 225602" src="https://github.com/user-attachments/assets/68d99c0e-4cd7-4bc7-94d9-684ddebd0ec4" />

*Employee retention correlates strongly with tenure, underscoring the value of long-term engagement.*

---

### 8. Average Daily Rate by Education Field: Find out the average daily rate of employees, categorized by their field of education.

```python
avg_daily_rate_by_education = df.groupby('education')['dailyrate'].mean().reset_index().round(1).sort_values('dailyrate',ascending=False)
avg_daily_rate_by_education
plt.figure(figsize=(10,6))
ax = sns.barplot(data = avg_daily_rate_by_education,x='dailyrate',y='education',width=0.4,palette='tab20c')
plt.title('Average Daily Rate by Education')
plt.xlabel('Daily Rate')
plt.ylabel('Education')
plt.xlim(right = avg_daily_rate_by_education['dailyrate'].max()*1.1)
for i in ax.containers:
    ax.bar_label(i,fontsize=9,label_type='center',padding=-150)
plt.tight_layout()
plt.show()
```

<img width="1233" height="732" alt="Screenshot 2025-08-11 225651" src="https://github.com/user-attachments/assets/5a7df077-c6b7-42c3-88bb-426d8a184a51" />

*Higher education levels are consistently rewarded with superior daily rates, reflecting organizational investment in expertise.*

---

### 9. Departmental Performance Ratings: Identify which departments have the highest average employee performance ratings.

```python
performancerating_by_dept = df.groupby('department')['performancerating'].mean().reset_index().round(2).sort_values('performancerating',ascending=False)
performancerating_by_dept
```

<img width="435" height="143" alt="Screenshot 2025-08-11 225737" src="https://github.com/user-attachments/assets/4bc6de5b-29a2-4f8e-85b5-a68ee897f5ed" />

*Departments consistently nurture high performance, driving strong results across the organization.*

---

### 10. Employee Education Level Distribution: Understand the number of employees at each education level within the company.

```python
emps_by_education = df['education'].value_counts().reset_index()
emps_by_education
plt.figure(figsize=(10,6))
ax = sns.barplot(data = emps_by_education,x='count',y='education',width=0.4,palette='Pastel2')
plt.title('Total Employees Distribution by Education Level')
plt.xlabel('Employees Count')
plt.ylabel('Education Level')
plt.grid(axis='x',visible=10)
plt.xlim(right = emps_by_education['count'].max()*1.1)
for i in ax.containers:
    ax.bar_label(i,fontsize=9,label_type='edge',padding=4)
plt.tight_layout()
plt.show()
```

<img width="1235" height="733" alt="Screenshot 2025-08-11 225835" src="https://github.com/user-attachments/assets/76beb6d2-6f40-4681-9383-5398a0e2d9db" />

*A well-balanced educational mix fuels the company’s adaptability and knowledge base.*

---

## Key Findings & Insights

### Attrition & Workforce Analysis:
- The overall employee attrition rate is ~16%.
- Overtime work and lack of recent promotions are significant attrition drivers.
- Most employees report high satisfaction, but pockets of low work-life balance and job satisfaction exist.
- Executive and managerial roles have higher compensation; most employees earn below the mean.
- Strong correlations exist between income, job level, and total working years.

### Recommendations:
- Focus on improving work-life balance to reduce overtime-driven attrition.
- Consider targeted retention strategies for employees with long periods since last promotion.
- Monitor satisfaction metrics and prioritize interventions for at-risk employee segments.

## Contact Info

- Mobile : +91 6303337487
- Email : [kambamsanthosh@gmail.com](mailto:kambamsanthosh@gmail.com)
- LinkedIn : [https://www.linkedin.com/in/santhosh-kambam/](https://www.linkedin.com/in/santhosh-kambam/)
