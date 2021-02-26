import pandas as pd
import numpy as np
import headm
import matplotlib.pyplot as plt

x = headm.Heading_Corr()

data = pd.read_excel("test.xlsx")

data.Var2_2 = data.Var2_2 +0.1
data.Var2_3 = data.Var2_3 -0.1
time = data.Var1.to_list()
q1_1 = data.Var2_1.to_list()
q1_2 = data.Var2_2.to_list()
q1_3 = data.Var2_3.to_list()
q1_4 = data.Var2_4.to_list()

q2_1 = data.Var4_1.to_list()
q2_2 = data.Var4_2.to_list()
q2_3 = data.Var4_3.to_list()
q2_4 = data.Var4_4.to_list()



q1 = list(np.array([q1_1,q1_2,q1_3,q1_4]).flatten())
q2 = list(np.array([q2_1,q2_2,q2_3,q2_4]).flatten())
print("1")
print(len(time))
print(len(q1))
x.set_input(time,q1,q2,100)

delta,df,rw,still = x.step()
#print(delta[:50])
#print(df[:50])
#print(rw[:50])
#print(still[:50])
#plt.plot(delta)
#plt.show()


q1 = list(np.array([q1_1[:10000],q1_2[:10000],q1_3[:10000],q1_4[:10000]]).flatten())
q2 = list(np.array([q2_1[:10000],q2_2[:10000],q2_3[:10000],q2_4[:10000]]).flatten())
print(len(time[:10000]))
print(len(q1))
print("2")
x.set_input(time[:10000],q1,q2,100)
print("3")

delta,df,rw,still = x.step()
#print(delta[:50])
#print(df[:50])
#print(rw[:50])
#print(still[:50])
plt.plot(delta)
plt.show()

