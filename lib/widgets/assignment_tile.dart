import 'package:flutter/material.dart';
import '../models/assignment.dart';

class AssignmentTile extends StatelessWidget {
  final Assignment assignment;
    final VoidCallback onDelete;
      final Function(bool?) onToggle;

        const AssignmentTile({
	    super.key,
	        required this.assignment,
		    required this.onDelete,
		        required this.onToggle,
			  });

			    @override
			      Widget build(BuildContext context) {
			          return ListTile(
				        title: Text(assignment.title),
					      subtitle: Text(
					              "${assignment.course} • Due: ${assignment.dueDate.day}/${assignment.dueDate.month}/${assignment.dueDate.year}",
						            ),
							          leading: Checkbox(
								          value: assignment.completed,
									          onChanged: onToggle,
										        ),
											      trailing: IconButton(
											              icon: const Icon(Icons.delete, color: Colors.red),
												              onPressed: onDelete,
													            ),
														        );
															  }
															  }
