unit MthRound; 

interface

(*
AP> H������ �������� ����������� � "�������������" ������
AP> ������� Round ��� ���������� ����� $N+ (� �������, Round(0.5)=0).
� ���� �p��� ���� �����y��� �� ��y �p�����y. H�������� � �������, ��� BUG ���p������p�.
���� � ���, ��� Round �p� N+ p�����y���� (��. we87.asm �� RTL) �������� FISTP, ����p�� ��
���������� (��� ����) �p������ ���p������� ��py����� ����� +/- 0.5, 2.5, 4.5 � �.�.
������� ��� �p��y��������� y��������� �������� ��������� ���� ��������
(����� �����-���y�� 0.49999999 ���� "��py������" �� 1, �� ��� ���p�� ����� �� ������):
*)
Function MRound(E: Extended { ����� ���. ���, �p��� Real } ): LongInt;

implementation

Function MRound(E: Extended { ����� ���. ���, �p��� Real } ): LongInt;
begin
  asm
    or byte ptr E, 1
  end;
  MRound:=Round(E);
end;

end.

