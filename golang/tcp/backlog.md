# Backlog����

��socket����ΪLISTEN״̬֮�󣬱���Ϊ��ָ��һ��backlog������incoming connection���޳����С�

��ΪTCP�������ֵĹ�ϵ��connection ��Ҫ���� SYN RECEIVED ֮����ܵ��� ESTABLISHED ״̬��Ȼ����ܱ� accept��

ʵ��1:
backlog��ϵͳ����listen�Ĳ������������ö��еĴ�С������δ��ʱ����һ��SYN�������գ����̷���һ�� SYN/ACK �� ���� connection ������С��ȴ�����  ACK �����յ���connection תΪ ESTABLISHED״̬�� ���Զ����л�������״̬�� connection (SYN RECEIVED, ESTABLISHED)��ֻ�� ESTABLISHED�����Ӳ��ܱ� accept��

ʵ��2��
���������С�һ�� SYN ���У�δ��ɵ����ӣ���һ�� accept ���У����������ӣ�. SYN RECEIVED�����Ӽ��� SYN queue, �ȵ��յ�ACK����״̬תΪ ESTABLISHED ������ accept queue. ����ʵ���� backlog ָ������ accept queue �Ĵ�С��

http://veithen.github.io/2014/01/01/how-tcp-backlog-works-in-linux.html

BSDһ�㶼�ǵ�һ��ʵ�֡���������ʱ��ϵͳ���ᷢ�� SYN/ACK ��Ӧ SYN�� ����ͨ���������� SYN�����⵼�� client��retry��

Ŀǰ��Linuxһ�㶼��ʵ��2.

