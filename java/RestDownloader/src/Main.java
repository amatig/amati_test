import java.io.File;
import java.io.IOException;
import java.text.MessageFormat;
import java.util.Iterator;
import java.util.List;

import org.eclipse.jgit.api.Git;
import org.eclipse.jgit.diff.DiffEntry;
import org.eclipse.jgit.diff.DiffFormatter;
import org.eclipse.jgit.diff.RawTextComparator;
import org.eclipse.jgit.lib.Constants;
import org.eclipse.jgit.lib.IndexDiff;
import org.eclipse.jgit.lib.ObjectId;
import org.eclipse.jgit.lib.ObjectReader;
import org.eclipse.jgit.lib.Repository;
import org.eclipse.jgit.lib.Tree;
import org.eclipse.jgit.revwalk.RevCommit;
import org.eclipse.jgit.revwalk.RevWalk;
import org.eclipse.jgit.storage.file.FileRepositoryBuilder;
import org.eclipse.jgit.treewalk.CanonicalTreeParser;
import org.eclipse.jgit.treewalk.FileTreeIterator;
import org.eclipse.jgit.util.io.DisabledOutputStream;

/**
 * Show hot to open an exisiting repository.
 */
public class Main {
	
    public static void main(String [] args) {
	    File gitWorkDir = new File("/Users/amatig/Code/git/amati_test/");
	    File gitDir = new File(gitWorkDir, ".git");
	    try {
	        FileRepositoryBuilder builder = new FileRepositoryBuilder();
	        
	        Repository repository = builder.setGitDir(gitDir)
	        		.readEnvironment() // scan environment GIT_* variables
	        		.findGitDir() // scan up the file system tree
	        		.build();
	        
	        RevWalk rw = new RevWalk(repository);
	        
	        ObjectId head = repository.resolve(Constants.HEAD);
	        RevCommit commit = rw.parseCommit(head);
	        //RevCommit commit = rw.parseCommit(ObjectId.fromString("01443a0c47ae766671a1ab38535bd56901039fb9"));
	        RevCommit parent = rw.parseCommit(ObjectId.fromString("3d32c595a740ab70006cd13247377c57bea8eb9a"));
	        
	        DiffFormatter df = new DiffFormatter(DisabledOutputStream.INSTANCE);
	        df.setRepository(repository);
	        df.setDiffComparator(RawTextComparator.DEFAULT);
	        df.setDetectRenames(true);
	        
	        List<DiffEntry> diffs = df.scan(parent.getTree(), commit.getTree());
	        for (DiffEntry diff : diffs) {
	            System.out.println(MessageFormat.format("{0} {1} {2}", diff.getChangeType().name(), diff.getOldPath(), diff.getNewPath()));
	        }
	    } catch (Exception e) {
	        
	    }
    }
    
}

