# ST-ReID_test

Sorgente originaria ST-ReID: https://github.com/Wanggcong/Spatial-Temporal-Re-identification

Per eseguire test sui dataset seguire la seguente procedura:
  creare una nuova cartella chiamata "raw-dataset" all'interno della cartella contente gli script del programma
  
  1. Scaricare il dataset interessato ed estrarlo nella cartella "raw-dataset"
  
  2. Preparare il dataset all'elaborazione eseguendo lo script "prepare.py" o "prepare_[nome dataset].m" adeguato;
      Lo script "prepare.py" deve essere usato per elaborare i dataset "Market1501" o "DukeMTMC" e dovra essere eseguito chiamando:
      python prepare.py --Market
      Per gli altri script sarà invece sufficiente eseguirli direttamente su matlab
      
  3. Cominciare il training usando il comando:
      python train_prid.py --PCB --gpu_ids 0 --name ft_ResNet50_pcb_prid_e --erasing_p 0.5 --train_all --data_dir "F:\Utenti\Ivan\Desktop\Stage\Programmi\Spatial-Temporal-Re-identification-master\dataset\prid2011_rename" --batchsize 10
      notare che:
        il parametro "name" può essere modificato scegliendo di assegnare il nome che si preferisce al modello finale, che verrà salvato sotto la cartella "model";
        il parametro "data_dir" deve essere cambiato per indirizzare alla cartella contenente il dataset preparato;
        il parametro "gpu_ids" può essere cambiato in base al numero di GPU compatibili con CUDA disponibili al sistema; nel caso in cui se ne abbia una sola installata si ponga tale valore a 0 e se non se ne ha a disposizione nessuna, porlo a -1;
        il paraemtro "batchsize" può essere cambiato in base alla memoria RAM disponibile al sistema;
          notare che questi ultimi due parametri impattano direttamente sui tempi di addestramento del modello.
          
  4. Estrapolare le feature visuali usando il comando:
      python test_st_prid.py --PCB --gpu_ids 0 --name ft_ResNet50_pcb_prid_e --test_dir "F:\Utenti\Ivan\Desktop\Stage\Programmi\Spatial-Temporal-Re-identification-master\dataset\prid2011_rename" --batchsize 8ù
      valgono le note presentante sul comando precedente
      
  5. Calcolare la distribuzione spazio temporale usando il comando:
      python gen_st_model_prid.py --name ft_ResNet50_pcb_prid_e --data_dir "F:\Utenti\Ivan\Desktop\Stage\Programmi\Spatial-Temporal-Re-identification-master\dataset\prid2011_rename"
      valgono le note presentante sul comando precedente
      
  6. Valutare le performance finali del modello usando il comando:
      python evaluate_st.py --name ft_ResNet50_pcb_prid_e
 
I risultati dell'elaborazione saranno presentati all'interno della cartella, presente sotto la cartella "model", avendo il nome assegnato al parametro "name", in un file matlab chiamato "CMC_duke_two_stream_add5".

Link ai dataset per il download:
  - Market1501: http://www.liangzheng.com.cn/Datasets.html
  - CUHK03: http://www.ee.cuhk.edu.hk/~xgwang/CUHK_identification.html
  - iLIDS-ViD: http://www.eecs.qmul.ac.uk/~xiatian/downloads_qmul_iLIDS-VID_ReID_dataset.html
  - PRID2011: https://www.tugraz.at/institute/icg/research/team-bischof/lrs/downloads/prid11/

