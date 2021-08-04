package library;

import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.ArrayList;

public class SearchEngine {
	public static String parseBookSearchInput(String input) {
		String[] tokens = input.split("\\s+");
		String whereSentence = "";
		
		Pattern p = Pattern.compile("([&|]?)(~?)(book_name|library_name|author_name|publisher|publish_date):(\\d{2}\\/\\d{2}\\/\\d{2}-\\d{2}\\/\\d{2}\\/\\d{2}|[\\w%]+)");
		
		for (String token : tokens) {
			Matcher m = p.matcher(token);
			if (m.find()) {
				String and_or = m.group(1);
				String not = m.group(2);
				String attribute = m.group(3);
				String value = m.group(4);
				
				if ("&".equals(and_or)) {
					whereSentence += " and ";
				}
				else if ("|".equals(and_or)) {
					whereSentence += " or ";
				}
				
				if ("~".equals(not)) {
					whereSentence += " not ";
				}
				
				if ("publish_date".equals(attribute)) {
					Pattern p1 = Pattern.compile("(\\d{2}\\/\\d{2}\\/\\d{2})-(\\d{2}\\/\\d{2}\\/\\d{2})");
					Matcher m1 = p1.matcher(value);
					
					if (m1.find()) {
						whereSentence += attribute + 
								" between to_date('" + m1.group(1) + 
								"', 'yy/mm/dd') and to_date('" + 
								m1.group(2) + 
								"', 'yy/mm/dd') ";
					}
				}
				else {
					whereSentence += attribute + " like '" + value + "' ";
				}
			}
		}
		
		return whereSentence;
	}
	
	public static String parseBorrowSearchInput(String input) {
		String[] tokens = input.split("\\s+");
		ArrayList<String> tokensToAdd = new ArrayList<>();
		
		Pattern p = Pattern.compile("(book_name|library_name|borrow_date|return_date):(\\d{2}\\/\\d{2}\\/\\d{2}-\\d{2}\\/\\d{2}\\/\\d{2}|[\\w%]+)");
		
		for (String token : tokens) {
			Matcher m = p.matcher(token);
			if (m.find()) {
				String attribute = m.group(1);
				String value = m.group(2);
				
				if ("borrow_date".equals(attribute) || "return_date".equals(attribute)) {
					Pattern p1 = Pattern.compile("(\\d{2}\\/\\d{2}\\/\\d{2})-(\\d{2}\\/\\d{2}\\/\\d{2})");
					Matcher m1 = p1.matcher(value);
					
					if (m1.find()) {
						tokensToAdd.add(attribute + 
								" between to_date('" + m1.group(1) + 
								"', 'yy/mm/dd') and to_date('" + 
								m1.group(2) + 
								"', 'yy/mm/dd') ");
					}
				}
				else {
					tokensToAdd.add(attribute + " like '" + value + "'");
				}
			}
		}
		
		return String.join(" and ", tokensToAdd);
	}
}
