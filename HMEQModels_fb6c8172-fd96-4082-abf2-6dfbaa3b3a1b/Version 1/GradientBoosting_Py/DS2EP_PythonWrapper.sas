data sasep.out;
   dcl package pymas pm;
   dcl package logger logr('App.tk.MAS');
   dcl varchar(32767) character set utf8 pypgm;
   dcl double resultCode revision;
   dcl double "CLAGE";
   dcl double "CLNO";
   dcl double "DEBTINC";
   dcl double "DELINQ";
   dcl double "DEROG";
   dcl double "LOAN";
   dcl double "MORTDUE";
   dcl double "NINQ";
   dcl double "VALUE";
   dcl double "YOJ";
   dcl varchar(100) "EM_CLASSIFICATION";
   dcl double "EM_EVENTPROBABILITY";

   method score(
   double "LOAN",
   double "MORTDUE",
   double "VALUE",
   double "YOJ",
   double "DEROG",
   double "DELINQ",
   double "CLAGE",
   double "NINQ",
   double "CLNO",
   double "DEBTINC",
   in_out double resultCode,
   in_out double "EM_EVENTPROBABILITY",
   in_out varchar(100) "EM_CLASSIFICATION");

      resultCode = revision = 0;
      if null(pm) then do;
         pm = _new_ pymas();
         resultCode = pm.useModule('model_exec_c36bc500-f139-42ff-9c23-377c3301bc7d', 1);
         if resultCode then do;
            resultCode = pm.appendSrcLine('import sys');
            resultCode = pm.appendSrcLine('sys.path.append("/models/resources/viya/e95dec7a-18d3-44d0-b80c-132a334da421/")');
            resultCode = pm.appendSrcLine('import settings');
            resultCode = pm.appendSrcLine('settings.pickle_path = "/models/resources/viya/e95dec7a-18d3-44d0-b80c-132a334da421/"');
            resultCode = pm.appendSrcLine('import GradientBoostingScore');
            resultCode = pm.appendSrcLine('def scoreGradientBoosting(LOAN, MORTDUE, VALUE, YOJ, DEROG, DELINQ, CLAGE, NINQ, CLNO, DEBTINC):');
            resultCode = pm.appendSrcLine('    "Output: EM_EVENTPROBABILITY, EM_CLASSIFICATION"');
            resultCode = pm.appendSrcLine('    return GradientBoostingScore.scoreGradientBoosting(LOAN, MORTDUE, VALUE, YOJ, DEROG, DELINQ, CLAGE, NINQ, CLNO, DEBTINC)');

            revision = pm.publish(pm.getSource(), 'model_exec_c36bc500-f139-42ff-9c23-377c3301bc7d');
            if ( revision < 1 ) then do;
               logr.log( 'e', 'py.publish() failed.');
               resultCode = -1;
               return;
            end;
         end;
      end;

      resultCode = pm.useMethod('scoreGradientBoosting');
      if resultCode then do;
         logr.log('E', 'useMethod() failed. resultCode=$s', resultCode);
         return;
      end;
      resultCode = pm.setDouble('LOAN', "LOAN");
      if resultCode then
         logr.log('E', 'setDouble for LOAN failed.  resultCode=$s', resultCode);
      resultCode = pm.setDouble('MORTDUE', "MORTDUE");
      if resultCode then
         logr.log('E', 'setDouble for MORTDUE failed.  resultCode=$s', resultCode);
      resultCode = pm.setDouble('VALUE', "VALUE");
      if resultCode then
         logr.log('E', 'setDouble for VALUE failed.  resultCode=$s', resultCode);
      resultCode = pm.setDouble('YOJ', "YOJ");
      if resultCode then
         logr.log('E', 'setDouble for YOJ failed.  resultCode=$s', resultCode);
      resultCode = pm.setDouble('DEROG', "DEROG");
      if resultCode then
         logr.log('E', 'setDouble for DEROG failed.  resultCode=$s', resultCode);
      resultCode = pm.setDouble('DELINQ', "DELINQ");
      if resultCode then
         logr.log('E', 'setDouble for DELINQ failed.  resultCode=$s', resultCode);
      resultCode = pm.setDouble('CLAGE', "CLAGE");
      if resultCode then
         logr.log('E', 'setDouble for CLAGE failed.  resultCode=$s', resultCode);
      resultCode = pm.setDouble('NINQ', "NINQ");
      if resultCode then
         logr.log('E', 'setDouble for NINQ failed.  resultCode=$s', resultCode);
      resultCode = pm.setDouble('CLNO', "CLNO");
      if resultCode then
         logr.log('E', 'setDouble for CLNO failed.  resultCode=$s', resultCode);
      resultCode = pm.setDouble('DEBTINC', "DEBTINC");
      if resultCode then
         logr.log('E', 'setDouble for DEBTINC failed.  resultCode=$s', resultCode);
      resultCode = pm.execute();
      if (resultCode) then
         logr.log('E', 'Error: pm.execute failed.  resultCode=$s', resultCode);
      else do;
         "EM_EVENTPROBABILITY" = pm.getDouble('EM_EVENTPROBABILITY');
         "EM_CLASSIFICATION" = pm.getString('EM_CLASSIFICATION');
      end;
   end;

   method run();
      set SASEP.IN;
      score("LOAN","MORTDUE","VALUE","YOJ","DEROG","DELINQ","CLAGE","NINQ","CLNO","DEBTINC", resultCode, "EM_EVENTPROBABILITY","EM_CLASSIFICATION");
   end;
enddata;
