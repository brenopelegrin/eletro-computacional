

def svg_dims(path):
    with open(path) as arq:
        lis_file=arq.readlines()
        for i,line in enumerate(lis_file):
            if line.startswith('<svg'):
                if line.endswith('>\n'):
                    header=line
                    break
                else:
                    aux=[]
                    while not lis_file[i+1].endswith('>\n'):
                        aux.append(lis_file[i+1])
                        i+=1
                    aux.append(lis_file[i])
                    header=''.join(aux)
                    break    
    header=header.split(' ')
    dic={}
    for item in header:
        x=item.split('=')
        if x[0] in ['height', 'width']:
            dic[x[0]]=x[1]
            
    for item in dic:
        dic[item]=dic[item].strip('"')
        dic[item]=dic[item][:-2]
        dic[item]=float(dic[item])
    return dic